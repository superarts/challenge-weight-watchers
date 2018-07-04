import UIKit

/**
* A manager that handles CuisineTableView.
*/
class CuisineTableManager: NSObject, RequiresDependency {
	
	public var selectHandler: ((Int) -> Void)?
	
	private var cuisines = [CuisineModel]()
	private var tableView: UITableView
	
	required init(tableView: UITableView) {
		self.tableView = tableView
		super.init()
		tableView.delegate = self
		tableView.dataSource = self
	}
	public func reload(cuisines: [CuisineModel]) {
		self.cuisines = cuisines
		tableView.reloadData()
	}
}

/// Update TableView UI
extension CuisineTableManager: UITableViewDataSource {
	
	internal func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cuisines.count
	}
	
	internal func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
		
		let cell = (tableView.dequeueReusableCell(withIdentifier: "CuisineCell") as? CuisineTableCell) ?? CuisineTableCell(style: .value1, reuseIdentifier: "CuisineCell")

		let cuisine = cuisines[path.row]
		cell.viewModel = dependencyManager.cuisineCellViewModel()
		cell.viewModel.cuisine = cuisine
		
		return cell
	}
}

/// Handle TableView events
extension CuisineTableManager: UITableViewDelegate {
	
	internal func tableView(_ tableView: UITableView, didSelectRowAt path: IndexPath) {
		tableView.deselectRow(at: path, animated: true)
		self.selectHandler?(path.row)
	}
}
