//
//  HomeViewController.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 16/10/2021.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK:- Layout:-
    @IBOutlet weak var realTimeBTN: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var empryLocationView: UIView!

    //MARK:- Variable & Constants:
    lazy var viewModel: HomeViewModel  = {
        return HomeViewModel()
    }()
    var locations: [HomeCellViewModel]?
    let refreshControl = UIRefreshControl()

    //MARK:- Life Cycle:-
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupViewModel()
    }
   
    

    //MARK:- To change between 2 mode 'Real Time' and 'Single Update'
    @IBAction func realTimeAction(_ sender: Any) {
        
        let nameBTN = viewModel.switchBetweenMode()
        self.realTimeBTN.setTitle(nameBTN, for: .normal)
        
    }
  
    @objc func refresh(){
        viewModel.isFetch = true
        viewModel.fetchLocations()
      }

}

//MARK:- Setup View Model
extension HomeViewController {
    
    func setupViewModel() {

        viewModel.error = { [weak self] error in
            guard !error.isEmpty else {
                self?.errorView.isHidden = true
                return
            }
            self?.errorView.isHidden = false
        }
        
        viewModel.loading = { isLoading in
                guard isLoading else{
                    LoadingIndicator.shared.hide()
                    return
                }
            LoadingIndicator.shared.show(for: self.view)
        }
        
        viewModel.isRefresh = { [weak self] (isRefresh) in
            guard isRefresh else {
                self?.refreshControl.endRefreshing()
                return
            }
        }
        viewModel.locationsList = { [weak self] list in
            guard !list.isEmpty else {
                self?.empryLocationView.isHidden = false
                return
            }
            self?.empryLocationView.isHidden = true
            self?.tableView.reloadData()
        }
        
        
//        viewModel.modeAction = { [weak self] titleBTN in
//            self?.realTimeBTN.setTitle(titleBTN, for: .normal)
//        }
        viewModel.fetchLocations()
    }
    

}

//MARK:- Table View Data Source
extension HomeViewController: UITableViewDataSource {
    
    fileprivate func setupTableView(){
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        self.tableView.register(UINib(nibName: "HomeTableCell", bundle: nil), forCellReuseIdentifier: "HomeTableCell")
        self.tableView.tableFooterView = UIView()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as HomeTableCell
        cell.listCellViewModel = viewModel.cellViewModels[indexPath.row]
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
