//
//  HomeViewController.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 16/10/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK:- Layout:-
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var realTimeBTN: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alertView: AlertView!
    
    //MARK:- Variable & Constants:
    lazy var viewModel: HomeViewModel  = {
        return HomeViewModel()
    }()
    var locations: [HomeCellViewModel]?
    let refreshControl = UIRefreshControl()
    
    //MARK:- Life Cycle:-
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFonts()
        self.realTimeBTN.setTitle(AppUpdateStatus.getCurrentUpdateType().rawValue, for: .normal)
        setupTableView()
        setupViewModel()
        viewModel.fetchLocations()
    }
    
    private func loadFonts(){
        titleLB.font = UIFont.fonts(name: .bold, size: .size_2xl)
        self.realTimeBTN.titleLabel?.font = UIFont.fonts(name: .regular, size: .size_l)
    }
    
    //MARK:- To change between 2 mode 'Real Time' and 'Single Update'
    @IBAction func realTimeAction(_ sender: Any) {
        
        let nameBTN = viewModel.switchBetweenMode()
        self.realTimeBTN.setTitle(nameBTN, for: .normal)
    }
    
    //MARK:- Tp Refresh Update
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
                self?.alertView.isHidden = true
                return
            }
            self?.alertView.loadAlert( .error)
            self?.alertView.isHidden = false
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
                self?.alertView.loadAlert( .empty)
                self?.alertView.isHidden = false
                return
            }
            self?.alertView.isHidden = true
            self?.tableView.reloadData()
        }
        
    }
    
}

//MARK:- Table View Data Source
extension HomeViewController: UITableViewDataSource {
    
    fileprivate func setupTableView(){
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        self.tableView.register(cell: HomeTableCell.self)
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as HomeTableCell
//        if indexPath.row == 0 || indexPath.row == 10 {
        cell.listCellViewModel = viewModel.cellViewModels[indexPath.row]
//        }else {
//            cell.iconIMG.loadImage(urlName: "")
//            cell.nameLB.text = viewModel.cellViewModels[indexPath.row].name
//            cell.formattedAddressLB.text = viewModel.cellViewModels[indexPath.row].formattedAddress
//        }
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (UIDevice.current.userInterfaceIdiom == .pad) { return 120 }
        return 80
    }
}
