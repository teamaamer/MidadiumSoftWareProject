// lib/screens/admin/reports_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import '../../services/admin_service.dart';
import '../../models/report_data_model.dart'; // Import the model
import '../../widgets/custom_card.dart';
import '../../widgets/loading_indicator.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late Future<ReportData> _reportsFuture;

  // Define colors for charts consistently
    final List<Color> _pieColors = [AppColors.pending, AppColors.approved, AppColors.rejected];
   final List<Color> _barColors = [AppColors.primary, AppColors.secondary, AppColors.accent, Colors.teal, Colors.orange, Colors.purple, Colors.blueGrey, Colors.indigo, Colors.pink]; // Added more colors

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _reportsFuture = AdminService().getReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadReports,
      color: AppColors.primary,
      child: FutureBuilder<ReportData>(
        future: _reportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator(message: 'Generating reports...');
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading reports: ${snapshot.error}', style: AppTextStyles.bodyText1, textAlign: TextAlign.center));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No reports data available.', style: AppTextStyles.bodyText1));
          }

          final data = snapshot.data!;
return LayoutBuilder(
            builder: (context, constraints) {
              // Define breakpoint for two-column layout
              const double twoColumnBreakpoint = 800.0;
              final bool isWide = constraints.maxWidth >= twoColumnBreakpoint;
              
//           return ListView(
//             padding: const EdgeInsets.all(16.0),
//             children: [
//               // --- Course Status Section ---
//               Text('Course Status Overview', style: AppTextStyles.headline3),
//               const SizedBox(height: 12),
//               CustomCard(
//                 child: Column(
//                   children: [
//                      SizedBox(
//                         height: 200, // Give chart space
//                         child: _buildStatusPieChart(data),
//                      ),
//                      const SizedBox(height: 16),
//                      _buildLegend( // Add a legend
//                         {'Pending': AppColors.pending, 'Approved': AppColors.approved, 'Rejected': AppColors.rejected},
//                      ),
//                      const Divider(height: 24),
//                      _buildStatRow('Total Courses:', data.totalCourses.toString()),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // --- Subject Distribution ---
//                Text('Courses per Subject', style: AppTextStyles.headline3),
//                const SizedBox(height: 12),
//                CustomCard(
//                   child: SizedBox(
//                       height: 250,
//                       child: _buildDistributionBarChart(data.subjectDistribution, 'Subjects'),
//                   )
//                ),
//                const SizedBox(height: 24),

//                // --- Grade Distribution ---
//                 Text('Courses per Grade', style: AppTextStyles.headline3),
//                 const SizedBox(height: 12),
//                 CustomCard(
//                    child: SizedBox(
//                        height: 250,
//                        child: _buildDistributionBarChart(data.gradeDistribution, 'Grades'),
//                    )
//                 ),
//                 const SizedBox(height: 24),
//  // *** --- NEW: Student Overview Section --- ***
//               Text('Student Overview', style: AppTextStyles.headline3),
//               const SizedBox(height: 12),
//               CustomCard(
//                 child: Column(
//                   children: [
//                     _buildStatRow('Total Students:', data.totalStudents.toString()),
//                     const Divider(height: 24),
//                     Text('Student Distribution by Grade', style: AppTextStyles.subtitle1),
//                     const SizedBox(height: 12),
//                     SizedBox(
//                        height: 250, // Adjust height as needed
//                        child: _buildDistributionBarChart(data.studentGradeDistribution, 'Grades'),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//                 // --- Courses Per Teacher ---
//                  Text('Courses per Teacher (Top 10)', style: AppTextStyles.headline3),
//                  const SizedBox(height: 12),
//                  CustomCard(
//                     child: _buildTeacherCourseList(data.coursesPerTeacher),
//                  ),
//                  const SizedBox(height: 24),


//               // --- Placeholder Completion Rate ---
//               Text('Student Engagement (Placeholder)', style: AppTextStyles.headline3),
//               const SizedBox(height: 12),
//               CustomCard(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Avg. Course Completion (Sample)',
//                       style: AppTextStyles.subtitle1,
//                     ),
//                      const SizedBox(height: 4),
//                      Text(
//                        '(Note: Real completion data requires student progress tracking)',
//                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
//                      ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: LinearProgressIndicator(
//                               value: data.placeholderCompletionRate, // Value 0.0 to 1.0
//                               minHeight: 10,
//                               backgroundColor: AppColors.accent.withOpacity(0.2),
//                               valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Text(
//                           '${(data.placeholderCompletionRate * 100).toStringAsFixed(1)}%',
//                           style: AppTextStyles.subtitle1.copyWith(color: AppColors.accent),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
    // );

   // Define sections as widgets for easier layout management
              Widget courseStatusSection = _buildSection(
                title: 'Course Status Overview',
                child: CustomCard(
                  child: Column(children: [
                    SizedBox(height: 200, child: _buildStatusPieChart(data)),
                    const SizedBox(height: 16),
                    _buildLegend({'Pending': AppColors.pending, 'Approved': AppColors.approved, 'Rejected': AppColors.rejected}),
                    const Divider(height: 24),
                    _buildStatRow('Total Courses:', data.totalCourses.toString()),
                  ]),
                ),
              );

              Widget subjectDistributionSection = _buildSection(
                title: 'Courses per Subject',
                child: CustomCard(child: SizedBox(height: 250, child: _buildDistributionBarChart(data.subjectDistribution, 'Subjects'))),
              );

               Widget courseGradeDistributionSection = _buildSection(
                title: 'Courses per Grade',
                child: CustomCard(child: SizedBox(height: 250, child: _buildDistributionBarChart(data.gradeDistribution, 'Grades'))),
              );

               Widget studentOverviewSection = _buildSection(
                title: 'Student Overview',
                child: CustomCard(
                  child: Column(children: [
                    _buildStatRow('Total Students:', data.totalStudents.toString()),
                    const Divider(height: 24),
                    Text('Student Distribution by Grade', style: AppTextStyles.subtitle1),
                    const SizedBox(height: 12),
                    SizedBox(height: 250, child: _buildDistributionBarChart(data.studentGradeDistribution, 'Grades')),
                  ]),
                ),
              );

              Widget teacherLoadSection = _buildSection(
                title: 'Courses per Teacher (Top 10)',
                child: CustomCard(child: _buildTeacherCourseList(data.coursesPerTeacher)),
              );

               Widget placeholderSection = _buildSection(
                 title: 'Student Engagement (Placeholder)',
                 child: CustomCard(/* ... placeholder content ... */
                     child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Avg. Course Completion (Sample)', style: AppTextStyles.subtitle1,),
                        const SizedBox(height: 4),
                        Text('(Note: Real completion data requires student progress tracking)', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),),
                        const SizedBox(height: 10),
                        Row( /* ... progress indicator row ... */
                           children: [
                            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: data.placeholderCompletionRate, minHeight: 10, backgroundColor: AppColors.accent.withOpacity(0.2), valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent), ), ), ),
                            const SizedBox(width: 12),
                            Text('${(data.placeholderCompletionRate * 100).toStringAsFixed(1)}%', style: AppTextStyles.subtitle1.copyWith(color: AppColors.accent),),
                          ],
                        ),
                      ],
                    ),
                 ),
               );

              // Build layout based on width
              if (isWide) {
                // Example: Two columns using nested Rows/Expanded
                return SingleChildScrollView( // Primary scroll view
                   padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded( // Column 1
                        child: Column(
                          children: [
                            courseStatusSection,
                            courseGradeDistributionSection,
                            teacherLoadSection,
                          ],
                        ),
                      ),
                      const SizedBox(width: 16), // Gutter
                      Expanded( // Column 2
                        child: Column(
                          children: [
                             studentOverviewSection,
                             subjectDistributionSection,
                             placeholderSection,
                          ],
                        ),
                      ),
                    ],
                  ),
                );

              } else {
                // Mobile: Single column ListView
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    courseStatusSection,
                    subjectDistributionSection,
                    courseGradeDistributionSection,
                    studentOverviewSection,
                    teacherLoadSection,
                    placeholderSection,
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }

  // Helper to build section with title and padding
  Widget _buildSection({required String title, required Widget child}) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 12.0), // Adjust padding
            child: Text(title, style: AppTextStyles.headline3),
          ),
          child,
          const SizedBox(height: 8), // Add consistent bottom space for sections
       ],
     );
  }

  

  // --- Chart Helper Widgets ---

  Widget _buildStatusPieChart(ReportData data) {
     if (data.totalCourses == 0) {
       return Center(child: Text('No courses yet.', style: AppTextStyles.bodyText2));
     }
    final List<PieChartSectionData> sections = [
       PieChartSectionData(
         color: AppColors.pending,
         value: data.pendingCourses.toDouble(),
         title: '${data.pendingCourses}',
         radius: 50,
         titleStyle: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
       ),
       PieChartSectionData(
         color: AppColors.approved,
         value: data.approvedCourses.toDouble(),
         title: '${data.approvedCourses}',
         radius: 50,
          titleStyle: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
       ),
       PieChartSectionData(
         color: AppColors.rejected,
         value: data.rejectedCourses.toDouble(),
         title: '${data.rejectedCourses}',
         radius: 50,
         titleStyle: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
       ),
    ];

    return PieChart(
       PieChartData(
         sections: sections,
         sectionsSpace: 2, // Space between sections
         centerSpaceRadius: 40, // Make it a donut chart
         pieTouchData: PieTouchData( // Disable interactions for simplicity
            touchCallback: (FlTouchEvent event, pieTouchResponse) {},
         ),
       ),
    );
  }

  Widget _buildLegend(Map<String, Color> items) {
     return Wrap( // Allows wrapping if too many items
       spacing: 16.0,
       runSpacing: 8.0,
       alignment: WrapAlignment.center,
       children: items.entries.map((entry) {
         return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               Container(width: 12, height: 12, color: entry.value),
               const SizedBox(width: 6),
               Text(entry.key, style: AppTextStyles.caption),
            ],
         );
       }).toList(),
     );
  }

  Widget _buildStatRow(String label, String value) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 4.0),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text(label, style: AppTextStyles.bodyText1),
           Text(value, style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold)),
         ],
       ),
     );
  }

Widget _buildDistributionBarChart(List<NameCountData> distributionData, String bottomAxisTitle) {
         if (distributionData.isEmpty) {
           return Center(child: Text('No data for $bottomAxisTitle distribution.', style: AppTextStyles.bodyText2));
         }

         final dataToShow = distributionData.take(10).toList();

         return BarChart(
            BarChartData(
               alignment: BarChartAlignment.spaceAround,
               maxY: (dataToShow.map((d) => d.count).reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),
               barTouchData: BarTouchData(enabled: false),
               titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) { // 'meta' is provided here
                             final index = value.toInt();
                             if (index >= 0 && index < dataToShow.length) {
                                return SideTitleWidget(
                                   // *** FIX IS HERE: Add the required meta parameter ***
                                   meta: meta,
                                   space: 4.0,
                                   child: Text(
                                      dataToShow[index].name,
                                      style: AppTextStyles.caption.copyWith(fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                   ),
                                );
                             }
                             return Container();
                          },
                          reservedSize: 30,
                      ),
                  ),
                   leftTitles: AxisTitles(
                     sideTitles: SideTitles(
                       showTitles: true,
                       reservedSize: 28,
                       // Apply same fix if needed for left titles (depends on what widget you return)
                       getTitlesWidget: (value, meta) => SideTitleWidget( // Pass meta here too if using SideTitleWidget
                         meta: meta,
                         child: Text(value.toInt().toString(), style: AppTextStyles.caption),
                       ),
                       interval: (dataToShow.map((d) => d.count).reduce((a, b) => a > b ? a : b) / 5).ceilToDouble(),
                     ),
                   ),
               ),
               borderData: FlBorderData(show: false),
               gridData: const FlGridData(show: false),
               barGroups: List.generate(dataToShow.length, (index) {
                  final item = dataToShow[index];
                  return BarChartGroupData(
                     x: index,
                     barRods: [
                       BarChartRodData(
                         toY: item.count.toDouble(),
                         color: _barColors[index % _barColors.length],
                         width: 16,
                         borderRadius: BorderRadius.circular(4),
                       ),
                     ],
                  );
               }),
            ),
         );
      }
  Widget _buildTeacherCourseList(List<NameCountData> teacherData) {
     if (teacherData.isEmpty) {
       return Center(child: Text('No teacher data available.', style: AppTextStyles.bodyText2));
     }
      // Limit the list length if desired
      final dataToShow = teacherData.take(10).toList();

     return ListView.separated(
        shrinkWrap: true, // Important inside Column/ListView
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling inside card
        itemCount: dataToShow.length,
        itemBuilder: (context, index) {
           final item = dataToShow[index];
           return ListTile(
              dense: true,
              leading: CircleAvatar(
                 radius: 15,
                 backgroundColor: _barColors[index % _barColors.length].withOpacity(0.2),
                 child: Text(
                   '${index+1}',
                   style: AppTextStyles.caption.copyWith(color:_barColors[index % _barColors.length], fontWeight: FontWeight.bold )
                  )
              ),
              title: Text(item.name, style: AppTextStyles.bodyText1),
              trailing: Text(
                 '${item.count} ${item.count == 1 ? "Course" : "Courses"}',
                 style: AppTextStyles.bodyText2.copyWith(fontWeight: FontWeight.w600),
              ),
           );
        },
         separatorBuilder: (context, index) => const Divider(height: 1),
     );
  }


}