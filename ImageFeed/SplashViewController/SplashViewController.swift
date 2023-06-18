import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let oAuth2Service = OAuth2Service()
    private let ShowAuthenticationScreenSegueIdentifier = "AuthenticationScreenSegueIdentifier"
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private let splashLogo: UIImageView = {
        let profileImage = UIImage(named: "splash_screen_logo")
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(named:"YP Gray")
        return imageView
    }()

    private func setupConstraints() {
        view.addSubview(splashLogo)
        splashLogo.heightAnchor.constraint(equalToConstant: 70).isActive = true
        splashLogo.widthAnchor.constraint(equalToConstant: 70).isActive = true
        splashLogo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        splashLogo.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        view.backgroundColor = UIColor(named:"YP Black")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = OAuth2TokenStorage.token {
            UIBlockingProgressHUD.show()
            profileService.fetchProfile(token) { [weak self] _ in
                guard let self else { return }
                self.profileImageService.fetchProfileImageURL(
                    token: token,
                    username: self.profileService.currentProfile!.username
                ) { _ in
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                }
            }
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let authViewController = storyboard.instantiateViewController(identifier: "AuthViewController") as? AuthViewController else { return }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        setupConstraints()
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assert(false)
            assertionFailure("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                OAuth2TokenStorage.token = token
                self.profileService.fetchProfile(token) { _ in
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }
}

extension SplashViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        let uiAlertAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(uiAlertAction)
        present(alert, animated: true)
    }
}
