import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {

    private var profileService = ProfileService.shared
    private var profileImageServise = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?

    let avatarImageView = UIImageView(image: UIImage(named: "profilePhoto"))
    let nameLabel = UILabel()
    let loginLabel = UILabel()
    let descriptionLabel = UILabel()
    let logoutButton = UIButton.systemButton(with: UIImage(named: "arrowForwardIcon")!, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setActions()
        profileView()
        setProfileInfo()

        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: profileImageServise.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.setAvatarImageView()
            }
        setAvatarImageView()
    }

    private func setAvatarImageView() {
        guard let avatarURL = profileImageServise.avatarURL else { return }
        DispatchQueue.main.async {
            self.avatarImageView.kf.indicatorType = .activity
            self.avatarImageView.kf.setImage(with: avatarURL)
        }
    }

    private func setProfileInfo() {
        guard let profile = profileService.currentProfile else { return }
        DispatchQueue.main.async {
            self.nameLabel.text = profile.name
            self.loginLabel.text = profile.loginName
            self.descriptionLabel.text = profile.bio
        }
    }

    private func setActions() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }

    @objc private func logoutButtonTapped() {
        descriptionLabel.removeFromSuperview()
    }

    func profileView(){

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.contentMode = .scaleAspectFill


        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font =  UIFont(name: "SF Pro", size: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true


        loginLabel.textColor = UIColor(named: "YP Gray")
        loginLabel.font =  UIFont(name: "SF Pro", size: 13)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true

        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font =  UIFont(name: "SF Pro", size: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true


        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }

}
