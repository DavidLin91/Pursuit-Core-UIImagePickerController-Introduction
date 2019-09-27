import UIKit

class ImagesViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet var imagesCollectionView: UICollectionView!
    
    // MARK: - Internal Properties
    
    var images = [UIImage]() {
        didSet {
            imagesCollectionView.reloadData()
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
    }
    
    // MARK: - IBActions
    
    @IBAction func addNewPhoto(_ sender: Any) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    @IBAction func addNewPhotoFromCamera(_ sender: Any) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .camera
        imagePickerVC.allowsEditing = true
        present(imagePickerVC, animated: true)
    }
    
    // MARK: - Private methods
    
    // https://nshipster.com/image-resizing/
    func resized(image: UIImage, for size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImagesViewController: UICollectionViewDelegateFlowLayout {}

// MARK: - UICollectionViewDataSource

extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionViewCell else {
            fatalError("Was expecting an ImageCollectionViewCell, but found a different type")
        }
        let image = images[indexPath.row]
        cell.imageView.image = resized(image: image, for: CGSize(width: 400, height: 400))
        return cell
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        images.append(image)
        dismiss(animated: true, completion: nil)
    }
}


