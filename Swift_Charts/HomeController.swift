//
//  ViewController.swift
//  Swift_Charts
//
//  Created by Dawei Hao on 2025/1/19.
//

import UIKit
import DGCharts

class HomeController: UIViewController {
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "Line Chart", at: 0, animated: true)
        sc.insertSegment(withTitle: "Chart 2", at: 1, animated: true)
        sc.insertSegment(withTitle: "Chart 3", at: 2, animated: true)
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    } ()
    
    private lazy var lineChartView: LineChartView = {
         let chartView = LineChartView()
         chartView.backgroundColor = .systemBackground
         
         // 基本配置
         chartView.rightAxis.enabled = false // 關閉右側 Y 軸
         chartView.legend.enabled = true     // 啟用圖例
         chartView.animate(xAxisDuration: 1.5) // 添加動畫效果
         
         // X 軸配置
         let xAxis = chartView.xAxis
         xAxis.labelPosition = .bottom
         xAxis.labelFont = .systemFont(ofSize: 10)
         xAxis.labelTextColor = .label
         xAxis.drawGridLinesEnabled = false
         
         // Y 軸配置
         let leftAxis = chartView.leftAxis
         leftAxis.labelFont = .systemFont(ofSize: 10)
         leftAxis.labelTextColor = .label
         leftAxis.axisMinimum = 0
         
         chartView.translatesAutoresizingMaskIntoConstraints = false
         return chartView
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        print("Red Background")
        
        setNavigationBar()
        setupChartView()
        updateChartData()
    }
    
    func setNavigationBar() {
        self.navigationItem.titleView = segmentedControl
    }

    private func setupChartView() {
        view.addSubview(lineChartView)
        
        NSLayoutConstraint.activate([
            lineChartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            lineChartView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lineChartView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    // 添加這個方法來顯示圖表數據
    private func updateChartData() {
        // 創建示例數據
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let values = [20.0, 45.0, 30.0, 60.0, 55.0, 70.0]
        
        // 創建數據條目
        var entries = [ChartDataEntry]()
        for (index, value) in values.enumerated() {
            let entry = ChartDataEntry(x: Double(index), y: value)
            entries.append(entry)
        }
        
        // 創建數據集
        let dataSet = LineChartDataSet(entries: entries, label: "銷售數據")
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 2
        dataSet.setColor(.systemBlue)
        dataSet.fill = ColorFill(color: .systemBlue.withAlphaComponent(0.1))
        dataSet.fillAlpha = 0.8
        dataSet.drawFilledEnabled = true
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 4
        dataSet.circleColors = [.systemBlue]
        dataSet.drawValuesEnabled = true
        
        // 設置 X 軸標籤
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        
        // 將數據集添加到圖表
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
    }
}

