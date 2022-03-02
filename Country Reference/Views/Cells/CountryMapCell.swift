//
//  CountryMapCell.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 02.03.22.
//

import UIKit
import MapKit
import Combine

class CountryMapCell: UITableViewCell {
    private lazy var mapView: MKMapView = .build(makeMapView)

    @Published
    var geographicDetails: CountryGeographicDetails?

    private var coordinateSubsciption: AnyCancellable?

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupCombine()
    }
}

// MARK: - UI EXT
private extension CountryMapCell {
    func setupUI() {
        _ = mapView
    }

    func makeMapView(_ v: inout MKMapView) {
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 4
        v.clipsToBounds = true
        self.addSubview(v)
        [
            v.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 4),
            v.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            v.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            v.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -4)
        ].activate()
    }
}

// MARK: - Combine EXT
private extension CountryMapCell {
    func setupCombine() {
        coordinateSubsciption = $geographicDetails
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] details in
                guard let `self` = self else { return }

                // No data representing latitudal or longitudal length of the country.
                // So we get the approximate length by assuming the shape as square.
                let approximateLatLong = details.area.squareRoot() * 1000

                let region = MKCoordinateRegion(center: details.coordinates, latitudinalMeters: approximateLatLong, longitudinalMeters: approximateLatLong)
                let adjustedRegion = self.mapView.regionThatFits(region)
                self.mapView.setRegion(adjustedRegion, animated: false)
            }
    }
}
