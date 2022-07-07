import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyLineChart extends StatefulWidget {
  final double minX, maxX, minY, maxY, interval;
  final List<FlSpot> spots;

  const MyLineChart({
    Key? key,
    required this.spots,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.interval,
  }) : super(key: key);

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  final List<Color> gradientColors = [
    Colors.green,
    const Color(0xff12a62d)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LineChart(
        LineChartData(
          minX: widget.minX,
          maxX: widget.maxX,
          minY: widget.minY,
          maxY: widget.maxY,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: widget.interval,
                reservedSize: 42,
                getTitlesWidget: leftTitleWidgets,
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitleWidgets
              )
            )
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Theme.of(context).primaryColor,
            ),
          ),
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey,
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: widget.spots,
              isCurved: true,
              barWidth: 4,
              color: Colors.green,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors.map((c) => c.withOpacity(0.5)).toList()
                ),
              ),
            ),
          ],
        ),
      ),
    );   
  }

    Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    /*String text;
    switch (value.toInt()) {
      case 1:
        text = value.toString();
        break;
      case 3:
        text = value.toString();
        break;
      case 5:
        text = value.toString();
        break;
      default:
        return Container();
    }*/

    return Text(value.toString(), style: style, textAlign: TextAlign.left);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: Text(value.toString(), style: style, textAlign: TextAlign.left)
    );
  }
}