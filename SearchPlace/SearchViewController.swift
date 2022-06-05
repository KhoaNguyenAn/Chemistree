//
//  SearchViewController.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 5/6/2022.
//

import UIKit
import MapKit

var titlePicked: String?

class SearchViewController: UIViewController {

    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var placemarkToReturn: MKPlacemark?

    @IBOutlet weak var validButton: UIButton!
    @IBOutlet weak var searchResultsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        validButton.isHidden = true
        validButton.layer.cornerRadius = 15
    }

    @IBAction func AddAdressButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchVCToMapVC" {
            let selectedAdress = segue.destination as! MapViewController
            selectedAdress.returnedPlacemark = placemarkToReturn
        }
    }


}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension SearchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let completion = searchResults[indexPath.row]
        titlePicked = completion.title
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            print(String(describing: coordinate))
            guard let adressName = response?.mapItems[0].name else { return }
            print(adressName)
            guard let cityName = response?.mapItems[0].placemark.title else { return }
            print(cityName)
            self.placemarkToReturn = response!.mapItems[0].placemark
            self.validButton.isHidden = false
        }
    }
}

