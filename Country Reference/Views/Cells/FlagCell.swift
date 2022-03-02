//
//  FlagCell.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 02.03.22.
//

import UIKit
import Combine

class FlagCell: UITableViewCell {
    private lazy var flagImageView: UIImageView = .build(makeImageView)

    @Published
    var imageURLString: String = ""

    private var cancellables: [AnyCancellable] = []

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupCombine()
    }
}

// MARK: - UI EXT
private extension FlagCell {
    func setupUI() {
        _ = flagImageView
    }

    func makeImageView(_ v: inout UIImageView) {
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
private extension FlagCell {
    func setupCombine() {
        $imageURLString
            .compactMap { URL(string: $0) }
            .sink { [weak self] url in
                guard let `self` = self else { return }

                URLSession
                    .shared
                    .dataTaskPublisher(for: url)
                    .map { UIImage(data: $0.data) }
                    .replaceError(with: nil)
                    .receive(on: DispatchQueue.main)
                    .assign(to: \.image, on: self.flagImageView)
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
}
