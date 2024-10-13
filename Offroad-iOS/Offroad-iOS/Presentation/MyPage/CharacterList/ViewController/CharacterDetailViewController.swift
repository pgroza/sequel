//
//  CharacterDetailViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/13/24.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: SelectMainCharacterDelegate?
    
    private let characterId: Int
    
    private let characterDetailView = CharacterDetailView()
    
    private var characterMainColorCode: String?
    private var characterSubColorCode: String?
    
    private var combinedCharacterMotionList: [(isGained: Bool, character: Any)] = [] //{
//        didSet {
//            DispatchQueue.main.async {
//                self.characterDetailView.collectionView.reloadData()
//            }
//        }
//    }
    
    var combinedCharacterMotionDict: [ORBCharacter: Bool] = [:]
    
    private let representativeCharacterId: Int
    //    private var gainedCharacterMotionList: [ORBCharacterMotion]?
    //    private var notGainedCharacterMotionList: [ORBCharacterMotion]?
    private var characterInfoModelList: [ORBCharacter]?
    
    // MARK: - Life Cycle
    
    init(characterId: Int, representativeCharacterId: Int) {
        self.characterId = characterId
        self.representativeCharacterId = representativeCharacterId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = characterDetailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if characterId == representativeCharacterId {
            characterDetailView.selectButton.isEnabled = false
            characterDetailView.selectButton.setTitle("이미 선택된 캐릭터예요", for: .normal)
            characterDetailView.selectButton.backgroundColor = UIColor.blackOpacity(.black25)
            characterDetailView.mainCharacterBadgeView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupDelegate()
        characterMotionInfo()
        getCharacterDetailInfo()
    }
    
}

extension CharacterDetailViewController {
    
    // MARK: - Private Func
    
    private func setupTarget() {
        characterDetailView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        characterDetailView.selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        characterDetailView.collectionView.delegate = self
        characterDetailView.collectionView.dataSource = self
    }
    
    private func getCharacterDetailInfo() {
        NetworkService.shared.characterDetailService.getAcquiredCharacterInfo(characterId: characterId) { response in
            switch response {
            case .success(let characterDetailResponse):
                guard let characterData = characterDetailResponse?.data else { return }
                
                self.characterMainColorCode = characterData.characterMainColorCode
                self.characterSubColorCode = characterData.characterSubColorCode
                self.view.backgroundColor = UIColor(hex: characterData.characterSubColorCode)
                self.characterDetailView.characterImage.fetchSvgURLToImageView(svgUrlString: characterData.characterBaseImageUrl)
                self.characterDetailView.characterLogoImage.fetchSvgURLToImageView(svgUrlString: characterData.characterIconImageUrl)
                self.characterDetailView.nameLabel.text = characterData.characterName
                self.characterDetailView.titleLabel.text = characterData.characterSummaryDescription
                self.characterDetailView.detailLabel.text = characterData.characterDescription
                self.characterDetailView.detailLabel.setLineSpacing(spacing: 5)
                self.characterDetailView.mainCharacterToastMessageView.setMessage(characterName: characterData.characterName)
                
                DispatchQueue.main.async {
                    self.characterDetailView.collectionView.reloadData()
                }
            default:
                break
            }
        }
    }
    
    private func characterMotionInfo() {
        NetworkService.shared.characterMotionService.getCharacterMotionList(characterId: characterId) { response in
            switch response {
            case .success(let result):
                guard let result else { return }
//                guard let motionData = result.data else { return }
//                print("Character Motion: \(motionData)")
//                self.gainedCharacterMotionList = data?.data.gainedCharacterMotions
//                self.notGainedCharacterMotionList = data?.data.notGainedCharacterMotions
                
//                self.combinedCharacterMotionList = []
//                self.gainedCharacterMotionList?.forEach { gainedCharacterMotion in
//                    self.combinedCharacterMotionList.append((isGained: true, character: gainedCharacterMotion))
//                }
//                self.notGainedCharacterMotionList?.forEach { notGainedCharacterMotion in
//                    self.combinedCharacterMotionList.append((isGained: false, character: notGainedCharacterMotion))
//                }
                
                self.combinedCharacterMotionList.append(
                    contentsOf: result.data.gainedCharacterMotions.map { (isGained: true, character: $0) }
                )
                self.combinedCharacterMotionList.append(
                    contentsOf: result.data.notGainedCharacterMotions.map { (isGained: false, character: $0) }
                )
                
                self.characterDetailView.collectionView.reloadData()
                
            default:
                break
            }
        }
    }
    
    private func postCharacterID() {
        NetworkService.shared.characterService.postChoosingCharacter(parameter: characterId) { response in
            switch response {
            case .success(let response):
                print("=======대표 캐릭터 설정: " + "\(response?.data.characterImageUrl)========")
            default:
                break
            }
        }
    }
    
    // MARK: - @objc Func
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func selectButtonTapped() {
        // 토스트 메세지가 떠 있는 동안엔 버튼 비활성화
        characterDetailView.selectButton.isEnabled = false
        characterDetailView.showToastMessage { [weak self] in
            self?.characterDetailView.selectButton.setTitle("이미 선택된 캐릭터예요", for: .normal)
            self?.characterDetailView.selectButton.backgroundColor = UIColor.blackOpacity(.black25)
            self?.characterDetailView.mainCharacterBadgeView.isHidden = false
        }
        postCharacterID()
        //CharacterListViewController에 대표 캐릭터 Id 전달
        delegate?.didSelectMainCharacter(characterId: characterId)
    }
}

//MARK: - UICollectionViewDataSource

extension CharacterDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return combinedCharacterMotionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailCell.className, for: indexPath) as? CharacterDetailCell else {
            fatalError("Could not dequeue CharacterDetailCell")
        }
        
        let characterMotionData = combinedCharacterMotionList[indexPath.item]
        
        if characterMotionData.isGained, let gainedCharacterMotion = characterMotionData.character as? ORBCharacterMotion {
            cell.configureMotionCell(data: gainedCharacterMotion, isGained: true)
        } else if let notGainedCharacterMotion = characterMotionData.character as? ORBCharacterMotion {
            cell.configureMotionCell(data: notGainedCharacterMotion, isGained: false)
        }
        
        if let mainColor = self.characterMainColorCode, let subColor = self.characterSubColorCode {
            cell.configureCellColor(mainColor: mainColor, subColor: subColor)
        }
        
        DispatchQueue.main.async {
            self.characterDetailView.updateCollectionViewHeight()
        }
        
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension CharacterDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.item) selected")
    }
    
}
