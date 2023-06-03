import UIKit

final class ProfileViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        profileView()
        
    }
    
    private func profileView(){
        let avatarImageView = UIImageView(image: UIImage(named: "profilePhoto"))
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font =  UIFont(name: "SF Pro", size: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = UIColor(named: "YP Gray")
        loginLabel.font =  UIFont(name: "SF Pro", size: 13)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font =  UIFont(name: "SF Pro", size: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        
        let logoutButton = UIButton.systemButton(with: UIImage(named: "arrowForwardIcon")!, target: nil, action: nil)
        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}
