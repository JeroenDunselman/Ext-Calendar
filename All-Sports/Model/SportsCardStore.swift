import UIKit

struct SportsCardStore {
  
  static func eventCards() -> [SportsCard] {
    return parseEventCards()
  }
  static func statsCards() -> [SportsCard] {
    return parseStatCards()
  }

  fileprivate static func parseStatCards() -> [SportsCard] {

    let filePath = Bundle.main.path(forResource: "Wildlife", ofType: "plist")!
    let dictionary = NSDictionary(contentsOfFile: filePath)!
    let cardData = dictionary["Wildlife"] as! [[String : String]]
    
    let cards = cardData.map { dict -> SportsCard in
      if let key = dict["matchItemKey"] {
      return SportsCard(
        name: dict["name"]!,
        description: dict["description"]!,
        matchItemKey: key
//        ,
//        image: UIImage(named: dict["image"]!)!
      )
      } else {
        return SportsCard(
          name: dict["name"]!,
          description: dict["description"]!,
          matchItemKey: nil
          //        ,
          //        image: UIImage(named: dict["image"]!)!
        )

      }
    }
    
    return cards
  }

  fileprivate static func parseEventCards() -> [SportsCard] {
    let filePath = Bundle.main.path(forResource: "Pets", ofType: "plist")!
    let dictionary = NSDictionary(contentsOfFile: filePath)!
    let cardData = dictionary["Pets"] as! [[String : String]]
    
    let cards = cardData.map { dict -> SportsCard in
      if let key = dict["matchItemKey"] {
        return SportsCard(
          name: dict["name"]!,
          description: dict["description"]!,
          matchItemKey: key
          //        ,
          //        image: UIImage(named: dict["image"]!)!
        )
      } else {
        return SportsCard(
          name: dict["name"]!,
          description: dict["description"]!,
          matchItemKey: nil
          //        ,
          //        image: UIImage(named: dict["image"]!)!
        )
        
      }
    }
    
    return cards
  }
//  
//  fileprivate static func parseStatsCards() -> [PetCard] {
//    
//    let filePath = Bundle.main.path(forResource: "Pets", ofType: "plist")!
//    let dictionary = NSDictionary(contentsOfFile: filePath)!
//    let cardData = dictionary["Pets"] as! [[String : String]]
//    
//    let cards = cardData.map { dict -> PetCard in
//      return PetCard(
//        name: dict["name"]!,
//        description: dict["description"]!,
//        image: UIImage(named: dict["image"]!)!)
//    }
  
//    return cards
//  }
}
