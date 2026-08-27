import 'package:flutter/material.dart';

void main() {
  runApp(const HRManagementApp());
}

class HRManagementApp extends StatelessWidget {
  const HRManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HR Management Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF315CFF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const HRHome(),
    );
  }
}

class HRHome extends StatefulWidget {
  const HRHome({super.key});

  @override
  State<HRHome> createState() => _HRHomeState();
}

class _HRHomeState extends State<HRHome> {
  int selected = 0;

  final List<String> titles = [
    'Dashboard',
    'Employees',
    'Attendance',
    'Leave',
    'Payroll',
  ];

  final List<Employee> employees = [
    Employee('E-001', 'Sarah Johnson', 'HR Manager', 'HR', 4200),
    Employee('E-002', 'Michael Brown', 'UI Designer', 'Design', 3800),
    Employee('E-003', 'Emma Wilson', 'Developer', 'IT', 4500),
    Employee('E-004', 'James Smith', 'Accountant', 'Finance', 3600),
  ];

  final List<LeaveRequest> leaves = [
    LeaveRequest('Sarah Johnson', 'Annual Leave', 'Approved'),
    LeaveRequest('Michael Brown', 'Sick Leave', 'Pending'),
    LeaveRequest('Emma Wilson', 'Personal Leave', 'Pending'),
  ];

  final Map<String, String> attendance = {
    'Sarah Johnson': 'Present',
    'Michael Brown': 'Present',
    'Emma Wilson': 'Leave',
    'James Smith': 'Present',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        selected: selected,
        onSelected: (index) {
          setState(() => selected = index);
          Navigator.pop(context);
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          titles[selected],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SafeArea(
        child: _page(),
      ),
    );
  }

  Widget _page() {
    switch (selected) {
      case 1:
        return EmployeesPage(
          employees: employees,
          onChanged: () => setState(() {}),
        );
      case 2:
        return AttendancePage(
          employees: employees,
          attendance: attendance,
          onChanged: () => setState(() {}),
        );
      case 3:
        return LeavePage(
          leaves: leaves,
          onChanged: () => setState(() {}),
        );
      case 4:
        return PayrollPage(employees: employees);
      default:
        return DashboardPage(
          employees: employees,
          attendance: attendance,
          leaves: leaves,
        );
    }
  }
}

// ================= DRAWER =================

class AppDrawer extends StatelessWidget {
  final int selected;
  final Function(int) onSelected;

  const AppDrawer({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    child: Icon(Icons.business_center, size: 31),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'HR Management',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Employee Management',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(),
            _item(Icons.dashboard_outlined, 'Dashboard', 0),
            _item(Icons.people_outline, 'Employees', 1),
            _item(Icons.fact_check_outlined, 'Attendance', 2),
            _item(Icons.event_note_outlined, 'Leave', 3),
            _item(Icons.payments_outlined, 'Payroll', 4),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: selected == index,
      selectedTileColor:
      const Color(0xFF315CFF).withOpacity(.10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: () => onSelected(index),
    );
  }
}

// ================= DASHBOARD =================

class DashboardPage extends StatelessWidget {
  final List<Employee> employees;
  final Map<String, String> attendance;
  final List<LeaveRequest> leaves;

  const DashboardPage({
    super.key,
    required this.employees,
    required this.attendance,
    required this.leaves,
  });

  @override
  Widget build(BuildContext context) {
    final present =
        attendance.values.where((e) => e == 'Present').length;

    final onLeave =
        attendance.values.where((e) => e == 'Leave').length;

    final payroll =
    employees.fold<double>(0, (sum, e) => sum + e.salary);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Good morning, Admin 👋',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Here is your HR overview.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            StatCard(
              title: 'Employees',
              value: '${employees.length}',
              icon: Icons.people_outline,
            ),
            StatCard(
              title: 'Present Today',
              value: '$present',
              icon: Icons.check_circle_outline,
            ),
            StatCard(
              title: 'On Leave',
              value: '$onLeave',
              icon: Icons.event_busy_outlined,
            ),
            StatCard(
              title: 'Departments',
              value: _departments().toString(),
              icon: Icons.apartment_outlined,
            ),
          ],
        ),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Monthly Payroll',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '\$${payroll.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Total employee salaries',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        const Text(
          'Recent Employees',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        ...employees
            .take(3)
            .map((employee) => EmployeeCard(employee: employee)),

        const SizedBox(height: 10),

        const Text(
          'Leave Requests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        ...leaves.take(3).map(
              (leave) => LeaveCard(
            leave: leave,
            compact: true,
          ),
        ),
      ],
    );
  }

  int _departments() {
    return employees.map((e) => e.department).toSet().length;
  }
}

// ================= STAT CARD =================

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: const Color(0xFF315CFF),
            size: 28,
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= EMPLOYEES =================

class EmployeesPage extends StatefulWidget {
  final List<Employee> employees;
  final VoidCallback onChanged;

  const EmployeesPage({
    super.key,
    required this.employees,
    required this.onChanged,
  });

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  String search = '';

  Future<void> addEmployee() async {
    final name = TextEditingController();
    final role = TextEditingController();
    final department = TextEditingController();
    final salary = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Employee'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration:
                const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: role,
                decoration:
                const InputDecoration(labelText: 'Position'),
              ),
              TextField(
                controller: department,
                decoration:
                const InputDecoration(labelText: 'Department'),
              ),
              TextField(
                controller: salary,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(labelText: 'Salary'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (name.text.isEmpty ||
                  role.text.isEmpty ||
                  department.text.isEmpty) {
                return;
              }
              Navigator.pop(context, true);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result == true) {
      widget.employees.add(
        Employee(
          'E-${widget.employees.length + 1}'.padLeft(5, '0'),
          name.text.trim(),
          role.text.trim(),
          department.text.trim(),
          double.tryParse(salary.text) ?? 0,
        ),
      );
      widget.onChanged();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.employees.where((e) {
      return e.name.toLowerCase().contains(search.toLowerCase()) ||
          e.department.toLowerCase().contains(search.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            onChanged: (value) => setState(() => search = value),
            decoration: InputDecoration(
              hintText: 'Search employees...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(
            child: Text('No employees found'),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final employee = filtered[index];

              return Dismissible(
                key: ValueKey(employee.id),
                background: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  alignment: Alignment.centerRight,
                  padding:
                  const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (_) {
                  widget.employees.remove(employee);
                  widget.onChanged();
                },
                child: EmployeeCard(
                  employee: employee,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: addEmployee,
              icon: const Icon(Icons.add),
              label: const Text('Add Employee'),
            ),
          ),
        ),
      ],
    );
  }
}

// ================= ATTENDANCE =================

class AttendancePage extends StatelessWidget {
  final List<Employee> employees;
  final Map<String, String> attendance;
  final VoidCallback onChanged;

  const AttendancePage({
    super.key,
    required this.employees,
    required this.attendance,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        final status = attendance[employee.name] ?? 'Absent';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    child: Icon(Icons.person_outline),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          employee.department,
                          style:
                          const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _statusColor(status),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        attendance[employee.name] = 'Present';
                        onChanged();
                      },
                      child: const Text('Present'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        attendance[employee.name] = 'Absent';
                        onChanged();
                      },
                      child: const Text('Absent'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        attendance[employee.name] = 'Leave';
                        onChanged();
                      },
                      child: const Text('Leave'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _statusColor(String status) {
    if (status == 'Present') return Colors.green;
    if (status == 'Leave') return Colors.orange;
    return Colors.red;
  }
}

// ================= LEAVE =================

class LeavePage extends StatelessWidget {
  final List<LeaveRequest> leaves;
  final VoidCallback onChanged;

  const LeavePage({
    super.key,
    required this.leaves,
    required this.onChanged,
  });

  Future<void> addLeave(BuildContext context) async {
    final name = TextEditingController();
    final reason = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply Leave'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration:
              const InputDecoration(labelText: 'Employee'),
            ),
            TextField(
              controller: reason,
              decoration:
              const InputDecoration(labelText: 'Leave Type'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (name.text.isEmpty || reason.text.isEmpty) return;
              Navigator.pop(context, true);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );

    if (result == true) {
      leaves.add(
        LeaveRequest(
          name.text.trim(),
          reason.text.trim(),
          'Pending',
        ),
      );
      onChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => addLeave(context),
        icon: const Icon(Icons.add),
        label: const Text('Apply Leave'),
      ),
      body: leaves.isEmpty
          ? const Center(
        child: Text('No leave requests'),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: leaves.length,
        itemBuilder: (context, index) {
          return LeaveCard(
            leave: leaves[index],
            onApprove: () {
              leaves[index].status = 'Approved';
              onChanged();
            },
            onReject: () {
              leaves[index].status = 'Rejected';
              onChanged();
            },
          );
        },
      ),
    );
  }
}

// ================= PAYROLL =================

class PayrollPage extends StatelessWidget {
  final List<Employee> employees;

  const PayrollPage({
    super.key,
    required this.employees,
  });

  @override
  Widget build(BuildContext context) {
    final total =
    employees.fold<double>(0, (sum, e) => sum + e.salary);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Payroll',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 7),
              Text(
                '\$${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ...employees.map(
              (employee) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person_outline),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        employee.position,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$${employee.salary.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ================= EMPLOYEE CARD =================

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  const EmployeeCard({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            child: Icon(Icons.person_outline),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  employee.position,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  employee.department,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '\$${employee.salary.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= LEAVE CARD =================

class LeaveCard extends StatelessWidget {
  final LeaveRequest leave;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool compact;

  const LeaveCard({
    super.key,
    required this.leave,
    this.onApprove,
    this.onReject,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final pending = leave.status == 'Pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                child: Icon(Icons.event_note_outlined),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      leave.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      leave.type,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                leave.status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: leave.status == 'Approved'
                      ? Colors.green
                      : leave.status == 'Rejected'
                      ? Colors.red
                      : Colors.orange,
                ),
              ),
            ],
          ),
          if (!compact && pending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: onApprove,
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ================= MODELS =================

class Employee {
  final String id;
  final String name;
  final String position;
  final String department;
  final double salary;

  Employee(
      this.id,
      this.name,
      this.position,
      this.department,
      this.salary,
      );
}

class LeaveRequest {
  final String name;
  final String type;
  String status;

  LeaveRequest(
      this.name,
      this.type,
      this.status,
      );
}