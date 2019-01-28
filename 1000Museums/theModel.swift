//
//  theModel.swift
//  1000Museums
//
//  Created by Brian Terry on 1/27/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//

import Foundation
import CoreData

class theModel {
    
    // Creates a singleton, and intitializes Core Data Globally.
    static let sharedInstance = theModel(persistenceManager:PersistenceManager.shared)
    let persistenceManager: PersistenceManager
    init(persistenceManager: PersistenceManager){
        self.persistenceManager = persistenceManager
    }
    

    // just a proof of concept.. currently just prints the artists supplied by this XML link
    func fetchArtistsFromWeb(){
      var parser = Parser()
        parser.parseFeed(url: "https://community.artauthority.net/aaservice.asp?action=artistlist")
    }
    
    // little example on how to create entities in core data for you guys.
    /*creating an "Entity"*/
    func createEntity(){
        let myEntity = TheEntity(context: theModel.sharedInstance.persistenceManager.context)
        myEntity.age = 5
        myEntity.name = "Will Smith"
        // this entity now exists in the "context" and has not yet been saved. Think of the context like a box you havent yet put into storage.
        // lets make a second one.
        let mySecondEntity = TheEntity(context: theModel.sharedInstance.persistenceManager.context)
        mySecondEntity.age = 10
        mySecondEntity.name = "Dwayne Johnson"
    }
    // This puts the box into storage.
    
    func save() {
        persistenceManager.save()
    }
    
    
    /*examples of core data at work
     Don't delete these, they will help guide you when you are building the model when fetching/ storing data.
    func weaponStoreInit(){
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Weapon")
            let weapons = try persistenceManager.context.fetch(fetchRequest) as? [Weapon]
            if(weapons!.count > 0){
                for i in weapons!{
                    print(i)
                }
                return
            }else{
                let weapon1 = Weapon(context: DunGen.sharedInstance.persistenceManager.context)
                weapon1.criticalRange = [19,20]
                weapon1.criticalDamage = 2
                weapon1.name = "Longsword"
                weapon1.damageDie = 8
                weapon1.damageType = "S"
                weapon1.goldValue = 15
                weapon1.weaponClass = "1-hand"
                weapon1.category = ["Projectile"]
                weapon1.range = 5
                
                
                
                let weapon2 = Weapon(context: DunGen.sharedInstance.persistenceManager.context)
                weapon2.criticalRange = [19,20]
                weapon2.criticalDamage = 3
                weapon2.name = "Spear"
                weapon2.damageDie = 8
                weapon2.damageType = "P"
                weapon2.goldValue = 2
                weapon2.weaponClass = "2-hand"
                weapon2.range = 10
                weapon2.category = ["Melee"]
                
                
                let weapon3 = Weapon(context: DunGen.sharedInstance.persistenceManager.context)
                weapon3.criticalRange = [20]
                weapon3.criticalDamage = 2
                weapon3.name = "ShortBow"
                weapon3.damageDie = 6
                weapon3.damageType = "P"
                weapon3.goldValue = 30
                weapon3.weaponClass = "2-hand"
                weapon3.range = 120
                weapon3.category = ["Projectile"]
                
                
                
                
                let weapon4 = Weapon(context: DunGen.sharedInstance.persistenceManager.context)
                weapon4.criticalRange = [20]
                weapon4.criticalDamage = 2
                weapon4.name = "Unarmed Strike"
                weapon4.damageDie = 3
                weapon4.damageType = "B"
                weapon4.goldValue = 0
                weapon4.weaponClass = "Light"
                weapon4.range = 5
                weapon4.category = ["Melee"]
                
                
                let weapon5 = Weapon(context: DunGen.sharedInstance.persistenceManager.context)
                weapon5.criticalRange = [19,20]
                weapon5.criticalDamage = 2
                weapon5.name = "Dagger"
                weapon5.damageDie = 4
                weapon5.damageType = "PS"
                weapon5.goldValue = 2
                weapon5.weaponClass = "Light"
                weapon5.range = 5
                weapon5.category = ["Melee", "Thrown"]
                print("Weapons Successfully Created")
            }
        }catch{
            print("error")
        }
    }
    func getOwnedWeapons() -> [Owns_Weapon]{
        
        return hero?.ownsWeapon?.allObjects as! [Owns_Weapon]
    }
    func getNumOwnedWeapons() -> Int{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Owns_Weapon")
            fetchRequest.predicate = NSPredicate(format: "heroToOwn.characterName = %@", (self.hero?.characterName)!)
            let weapons = try persistenceManager.context.fetch(fetchRequest) as? [Owns_Weapon]
            return weapons?.count ?? 0
        }catch{
            return 1
        }
    }
    func addWeapon(weapon: Weapon){
        let ownRelationship = Owns_Weapon(context: DunGen.sharedInstance.persistenceManager.context)
        ownRelationship.heroToOwn = hero!
        ownRelationship.weaponToOwn = weapon
    }
    func deleteWeapon(theOwnsWeapon: Owns_Weapon){
        if(theOwnsWeapon.weaponToOwn!.name != "Unarmed Strike"){
            print(getNumOwnedWeapons())
            persistenceManager.context.delete(theOwnsWeapon)
            print(getNumOwnedWeapons())
        }
    }
    func equipWeapon(to: String, theWeapon: Owns_Weapon) -> String?{
        if(to == "mainHand"){
            if(theWeapon.weaponToOwn!.weaponClass == "2-hand"){
                return "Weapon cannot be held with one hand."
            }
            if(self.hero?.weaponEquippedOff != nil){
                if (theWeapon === self.hero?.weaponEquippedOff){
                    return "Cannot equip the same weapon more than once."
                }
            }
            self.hero?.weaponEquippedMain = theWeapon
            self.hero?.weaponEquippedBoth = nil
            return nil
        }else if( to == "offHand"){
            if(self.hero?.weaponEquippedMain != nil){
                if(!(theWeapon.weaponToOwn!.weaponClass == "2-hand")){
                    return "Weapon cannot be held with one hand."
                }
                if (theWeapon === self.hero?.weaponEquippedMain){
                    return "Cannot equip the same weapon more than once."
                }else{
                    self.hero?.weaponEquippedOff = theWeapon
                    return nil
                }
            }else{
                return "Must equip Main hand before offhand."
            }
        }
        else if(to == "twoHand"){
            if(!(theWeapon.weaponToOwn!.weaponClass == "Light")){
                return "Weapon must be held with one hand."
            }
            self.hero?.weaponEquippedMain = nil
            self.hero?.weaponEquippedOff = nil
            self.hero?.weaponEquippedBoth = theWeapon
            return nil
        }
        return nil
    }
    func getWeaponEquipped() -> (Weapon?, Weapon?, Weapon?){
        return (self.hero?.weaponEquippedMain?.weaponToOwn ?? nil, self.hero?.weaponEquippedOff?.weaponToOwn ?? nil, self.hero?.weaponEquippedBoth?.weaponToOwn ?? nil)
    }
    func saveData(){
        persistenceManager.save()
    }
    func loadData(name: String){
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Hero")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "characterName = %@", name)
            let heros = try persistenceManager.context.fetch(fetchRequest) as? [Hero]
            if(heros!.count > 0){
                self.hero = heros?.first
            }
        }catch{
            print("error")
        }
    }
    func canLoad() -> Bool{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Hero")
            let heros = try persistenceManager.context.fetch(fetchRequest) as? [Hero]
            if(heros!.count > 0){
                return true
            }else{
                return false
            }
            
        }catch{
            print("error")
            return false
        }
    }
    func getNumOfSaves() -> Int{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Hero")
            let heros = try persistenceManager.context.fetch(fetchRequest) as? [Hero]
            if(heros!.count > 0){
                return heros!.count
            }else{
                return 0
            }
            
        }catch{
            print("error")
            return 0
        }
    }
    func getNamesOfSaves() -> [String]?{
        var stringArray: [String] = []
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Hero")
            let heros = try persistenceManager.context.fetch(fetchRequest) as? [Hero]
            if(heros!.count > 0){
                for hero in heros!{
                    stringArray.append(hero.characterName)
                }
            }else{
                return nil
            }
            
        }catch{
            print("error")
            return nil
        }
        return stringArray
    }
 */
}

