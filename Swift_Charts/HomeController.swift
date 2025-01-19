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
        sc.insertSegment(withTitle: "Pie Chart", at: 1, animated: true)
        sc.insertSegment(withTitle: "Bar Chart", at: 2, animated: true)
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
    
    private lazy var pieChartView: PieChartView = {
        let chartView = PieChartView()
        chartView.backgroundColor = .systemBackground
        
        // 基本配置
        chartView.legend.enabled = true
        chartView.animate(xAxisDuration: 1.5)
        
        // 圓餅圖特有配置
        chartView.drawHoleEnabled = true
        chartView.holeColor = .systemBackground
        chartView.holeRadiusPercent = 0.5
        chartView.drawEntryLabelsEnabled = true
        chartView.entryLabelColor = .label
        chartView.entryLabelFont = .systemFont(ofSize: 12)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
    private lazy var barChartView: BarChartView = {
        let chartView = BarChartView()
        chartView.backgroundColor = .systemBackground
        
        chartView.legend.enabled = true
        chartView.animate(xAxisDuration: 1.5)
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .regular)
        xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        
        chartView.rightAxis.enabled = false
        
        // 左 Y 軸配置
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawGridLinesEnabled = true         // 顯示水平網格線
        leftAxis.drawZeroLineEnabled = true          // 在零點處畫線
        leftAxis.axisMinimum = 0                     // 最小值從 0 開始
        
        // 其他視覺配置
        chartView.drawBarShadowEnabled = false       // 不顯示陰影
        chartView.drawValueAboveBarEnabled = true
        
        chartView.scaleYEnabled = true
        chartView.scaleXEnabled = true
        chartView.maxVisibleCount = 1
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setNavigationBar()
        setupChartView()
        setupPieChartView()
        setupBarChartView()
        
        updateChartData()
        updatePieChartData()  // 添加這行
        updateBarChartData()
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        // 初始狀態設置
        pieChartView.isHidden = true  // 預設隱藏圓餅圖
        barChartView.isHidden = true
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
    
    private func setupPieChartView() {
        view.addSubview(pieChartView)
        NSLayoutConstraint.activate([
            pieChartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            pieChartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            pieChartView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pieChartView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupBarChartView() {
        view.addSubview(barChartView)
        NSLayoutConstraint.activate([
            barChartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            barChartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            barChartView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            barChartView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func updatePieChartData() {
        // 創建示例數據
        let categories = ["食品", "交通", "娛樂", "購物", "其他"]
        let values = [30.0, 25.0, 20.0, 15.0, 10.0]
        
        // 創建數據條目
        var entries = [PieChartDataEntry]()
        for (index, value) in values.enumerated() {
            let entry = PieChartDataEntry(value: value, label: categories[index])
            entries.append(entry)
        }
        
        // 創建數據集
        let dataSet = PieChartDataSet(entries: entries, label: "支出分類")
        
        // 設置顏色
        dataSet.colors = [
            .systemBlue,
            .systemGreen,
            .systemOrange,
            .systemPurple,
            .systemPink
        ]
        
        // 數值標籤設置
        dataSet.valueFont = .systemFont(ofSize: 12)
        dataSet.valueTextColor = .label
        dataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter())
        
        // 將數據集添加到圖表
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
    }
    
    // 添加這個方法來顯示圖表數據
    private func updateChartData() {
        // 建立 月份 跟 數值
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let values = [20.0, 45.0, 30.0, 60.0, 55.0, 70.0]
        
        // 建立數據array
        var entries = [ChartDataEntry]()
        for (index, value) in values.enumerated() {
            let entry = ChartDataEntry(x: Double(index), y: value)
            entries.append(entry)
        }
        
        // 建立dataSet
        let dataSet = LineChartDataSet(entries: entries, label: "銷售數據")
        dataSet.mode = .cubicBezier // 設定樣式
        dataSet.lineWidth = 2       // 設定線寬
        dataSet.setColor(.systemPurple)   // 設定紫色
        
        // 設置漸層 由上到下
        let gradientColors = [UIColor.systemRed.cgColor,
                             UIColor.red.cgColor,
                             UIColor.systemRed.cgColor,
                             UIColor.white.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.7, 0.3, 0.0]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                    colors: gradientColors,
                                    locations: colorLocations) {
            
            // 調整漸層角度
            dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90.0)
        }
        
        dataSet.drawFilledEnabled = true
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 4
        dataSet.circleColors = [.purple] // 設置圓點顏色
        dataSet.drawValuesEnabled = true // 顯示數值
        
        // 設置 X 軸標籤
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        
        // 將數據集添加到圖表
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
    }
    
    private func updateBarChartData() {
        // 創建示例數據
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let values = [20.0, 45.0, 30.0, 60.0, 55.0, 70.0]
        
        // 創建數據條目
        var entries = [BarChartDataEntry]()
        for (index, value) in values.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value)
            entries.append(entry)
        }
        
        // 創建數據集
        let dataSet = BarChartDataSet(entries: entries, label: "月度銷售")
        
        // 設置柱狀圖顏色 - 使用漸層色
        dataSet.colors = values.map { value in
            // 根據數值大小設定不同深淺的藍色
            return UIColor.systemBlue.withAlphaComponent(CGFloat(value/100.0))
        }
        
        // 數值標籤格式
        dataSet.valueFont = .systemFont(ofSize: 12)
        dataSet.valueTextColor = .label
        dataSet.valueFormatter = DefaultValueFormatter(decimals: 0)
        
        // 設置 X 軸標籤
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        
        // 設置數據
        let data = BarChartData(dataSet: dataSet)
        data.setValueFont(.systemFont(ofSize: 12))
        
        // 設置柱狀圖寬度
        data.barWidth = 0.7
        
        // 將數據添加到圖表
        barChartView.data = data
        
        // 其他視覺設置
        barChartView.highlightPerDragEnabled = true  // 拖動時高亮顯示
        barChartView.highlightPerTapEnabled = true   // 點擊時高亮顯示
        
        // 描述文字
        barChartView.chartDescription.enabled = false
        
        // 刷新圖表
        barChartView.notifyDataSetChanged()
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // 先隱藏所有圖表
        lineChartView.isHidden = true
        pieChartView.isHidden = true
        barChartView.isHidden = true
        
        // 根據選擇顯示對應圖表
        switch sender.selectedSegmentIndex {
        case 0:
            lineChartView.isHidden = false
        case 1:
            pieChartView.isHidden = false
        default:
            barChartView.isHidden = false
            break
        }
    }
}

#Preview {
    UINavigationController(rootViewController: HomeController())
}
