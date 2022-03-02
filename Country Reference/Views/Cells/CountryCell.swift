//
//  CountryCell.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 02.03.22.
//

import UIKit
import Combine

class CountryCell: UITableViewCell {
    private lazy var flagImageView: UIImageView = .build(makeImageView)

    private lazy var labelStackView: UIStackView = .build(makeStackView)

    private lazy var nameLabel: UILabel = .build(makeLabel)

    private lazy var nativeNameLabel: UILabel = .build(makeLabel)

    @Published
    var name: String = ""

    @Published
    var nativeName: String = ""

    @Published
    var flagImageURLString: String = ""

    private var cancellables: [AnyCancellable] = []

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupCombine()

        self.selectionStyle = .blue
    }
}

// MARK: - UI EXT
private extension CountryCell {
    func setupUI() {
        _ = labelStackView

        nameLabel.text = ""
        nativeNameLabel.text = ""
    }

    func makeImageView(_ v: inout UIImageView) {
        v.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(v)
        [
            v.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            v.heightAnchor.constraint(equalTo: v.widthAnchor),
            v.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, constant: -12)
        ].activate()
        v.contentMode = .scaleAspectFit
    }

    func makeStackView(_ v: inout UIStackView) {
        v.translatesAutoresizingMaskIntoConstraints = false
        v.distribution = .fillEqually
        v.axis = .vertical

        self.addSubview(v)
        [
            v.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: self.flagImageView.trailingAnchor, constant: 12),
            v.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            v.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, constant: -6)
        ].activate()

        [
            nameLabel,
            nativeNameLabel
        ].forEach(v.addArrangedSubview)
    }

    func makeLabel(_ v: inout UILabel) {
        v.font = .systemFont(ofSize: 16, weight: .medium)
    }
}

// MARK: - Combine EXT
private extension CountryCell {
    func setupCombine() {
        $name
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: nameLabel)
            .store(in: &cancellables)

        $nativeName
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: nativeNameLabel)
            .store(in: &cancellables)

        $flagImageURLString
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
