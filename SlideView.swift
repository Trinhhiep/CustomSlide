//
//  SlideView.swift
//  Slide
//
//  Created by Admin on 28/05/2021.
//

import UIKit
import Kingfisher
class SlideView: UIView {
    
    let identifier = "SLIDECELL1"
    var numberOfItem : Int?
    var datsSource : SlideViewDatasource?
    var currentItem : IndexPath = IndexPath(row: 0, section: 0)
    fileprivate let collection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .infinite , collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
        
    }()
    
    fileprivate let pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
      
        return pc
    }()
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        setUpSlideView()
        DispatchQueue.main.async { [self] in
            guard let numberOfItem = datsSource?.slideView(numberOfItem: self) else{
                return
            }
            self.numberOfItem = numberOfItem
            pageControl.numberOfPages = numberOfItem
            pageControl.isEnabled = false
            pageControl.currentPage = 0
            collection.reloadData()
            collection.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        }
        
        
        
        
    }
    
    
    func setUpSlideView()  {
        
        // set Up Slide
        
        self.addSubview(collection)
        collection.frame =  CGRect(origin: self.bounds.origin, size: self.bounds.size)
        collection.register(SlideCell.self, forCellWithReuseIdentifier: identifier)
        collection.dataSource = self
        collection.delegate = self
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .white
        collection.isPagingEnabled = true // hien thị từng cell
        
        // setup size button
        let h = self.bounds.height/10 >= CGFloat(30) ? self.bounds.height/10 : CGFloat(30)
        let w = CGFloat(30)
        
        // set up btn Previous
        let btnPreviousPage : UIButton = {
            
            let btnPrevious = UIButton(frame: CGRect(x: self.bounds.minX , y: (self.bounds.maxY - h) / 2, width: w, height: h))
            btnPrevious.backgroundColor = .none
            btnPrevious.setImage(UIImage(systemName: "chevron.backward"), for: UIControl.State.normal)
//            btnPrevious.scalesLargeContentImage = true
            btnPrevious.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnPrevious.contentVerticalAlignment = .fill
            btnPrevious.contentHorizontalAlignment = .fill
            btnPrevious.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
            btnPrevious.addTarget(self, action: #selector(goPrevious(_:)), for: .touchDown)
            
            return btnPrevious
        }()
        
        self.addSubview(btnPreviousPage)
        
        // set up btn Next
        let btnNextPage : UIButton = {
            
            let btnNext : UIButton = UIButton(frame: CGRect(x: self.bounds.maxX - w , y: (self.bounds.maxY - h) / 2, width: w, height: h))
            btnNext.backgroundColor = .none
            btnNext.setImage(UIImage(systemName: "chevron.forward"), for: UIControl.State.normal)
//            btnNext.scalesLargeContentImage = true
            btnNext.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnNext.contentVerticalAlignment = .fill
            btnNext.contentHorizontalAlignment = .fill
            btnNext.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
            btnNext.addTarget(self, action: #selector(goNext(_:)), for: .touchDown)
            
            return btnNext
        }()
        
        self.addSubview(btnNextPage)
        
        // setup Page control
        
        self.addSubview(pageControl)
        pageControl.frame = CGRect(x: self.bounds.minX, y: self.bounds.maxY - h, width: self.bounds.width, height: h)
    }
    
    @objc func goPrevious(_ sender:UIButton) {
        
        let currentPage = pageControl.currentPage
        guard  currentPage > 0 else {
            return
        }
        let index = IndexPath(row: currentPage - 1 , section: 0)
        collection.selectItem(at: index, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        pageControl.currentPage = index.row
    }
    @objc func goNext(_ sender:UIButton) {
        
//        let currentPage = pageControl.currentPage
//
        
        guard let number = numberOfItem else {
            return
        }
        
//        let index = currentItem.row
//        let index = currentPage >= number - 1 ? IndexPath(row: 0 , section: 0) :  IndexPath(row: currentPage + 1 , section: 0)
        let index = IndexPath(row: currentItem.row  + 1 , section: 0)
      
        collection.selectItem(at: index, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        pageControl.currentPage = index.row % number
        self.currentItem = index
       
    }
    
}

extension SlideView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numberOfItem = datsSource?.slideView(numberOfItem: self) else{
            return 0
        }
        return numberOfItem * 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! SlideCell
        guard let num = numberOfItem,let url = (datsSource?.slideView(slideView: self, itemAt: indexPath.row % num)) else{
            return cell
        }
        cell.setImage(urlStr : url)
        return cell
    }
    
    
}
extension SlideView : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (collection.bounds.size)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}
extension SlideView:UICollectionViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // get index of item
        var visibleRect = CGRect()
        
        visibleRect.origin = collection.contentOffset
        visibleRect.size = collection.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        print(visiblePoint)
        guard let indexPath = collection.indexPathForItem(at: visiblePoint), let num = numberOfItem else { return }
        currentItem = indexPath
        pageControl.currentPage = indexPath.row % num
     
       
    }
    
    
}


protocol  SlideViewDatasource {
    
    func slideView( slideView : SlideView, itemAt indexPath : Int ) -> String
    func slideView( numberOfItem slideView : SlideView   ) -> Int
}


class SlideCell: UICollectionViewCell {
    
    fileprivate let imageView : UIImageView = {
        let iv = UIImageView()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    required init(coder : NSCoder) {
        super.init(coder: coder)!
    }
    
    func setImage(urlStr : String){
        DispatchQueue.main.async { [self] in
           
            let url = URL(string: urlStr)
            let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
                         |> RoundCornerImageProcessor(cornerRadius: 0)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
            
        }
    }
}
