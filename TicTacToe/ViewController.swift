//
//  ViewController.swift
//  TicTacToe
//
//  Created by CallumHill on 30/7/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore



class ViewController: UIViewController
{
	enum Turn {
		case Nought
		case Cross
	}
	
	@IBOutlet weak var turnLabel: UILabel!
	@IBOutlet weak var a1: UIButton!
	@IBOutlet weak var a2: UIButton!
	@IBOutlet weak var a3: UIButton!
	@IBOutlet weak var b1: UIButton!
	@IBOutlet weak var b2: UIButton!
	@IBOutlet weak var b3: UIButton!
	@IBOutlet weak var c1: UIButton!
	@IBOutlet weak var c2: UIButton!
	@IBOutlet weak var c3: UIButton!
	
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var reset: UIButton!
    
    var firstTurn = Turn.Cross
	var currentTurn = Turn.Cross


    let db = Firestore.firestore()
  
    
	
	var NOUGHT = "O"
	var CROSS = "X"
	var board = [UIButton]()
	
	var noughtsScore = 0
	var crossesScore = 0
    
    var player = 0


	
	override func viewDidLoad()
	{
		super.viewDidLoad()
        
		initBoard()
        
        db.collection("Game").document("Session")
            .addSnapshotListener { [self] documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
//              print("Current data: \(data)")
                for position in data {
                    if(position.key == "a1"){
                        a1.setTitle(position.value as? String, for: .normal)
                    }
                    if(position.key == "a2"){
                        a2.setTitle(position.value as? String, for: .normal)
                    }
                    if(position.key == "a3"){
                        a3.setTitle((position.value as? String), for: .normal)
                    }
                    if(position.key == "b1"){
                        b1.setTitle(position.value as? String, for: .normal)
                    }
                    if(position.key == "b2"){
                        b2.setTitle(position.value as? String, for: .normal)
                    }
                    if(position.key == "b3"){
                        b3.setTitle((position.value as? String), for: .normal)
                    }
                    if(position.key == "c1"){
                        c1.setTitle(position.value as? String, for: .normal)
                    }
                    if(position.key == "c2"){
                        c2.setTitle(position.value as? String, for: .normal)
                    }
                    if(position.key == "c3"){
                        c3.setTitle(position.value as? String, for: .normal)
                    }
                    if(position.key == "inSession"){
                        print(self.player)
                        print(position.value)
                        if (position.value as! String == "true" && self.player == 0)
                        {
                            self.start.setTitle("Join", for:.normal)
                            start.isEnabled = true
                            print("Join")
                        }
                         if(self.player == 1){
                            start.setTitle("Start", for:.normal)
                           
                            start.isEnabled = false
                            print("disabled")
                            
                        }
                        else if(position.value as! String == "false"){
                            self.start.setTitle("Start", for:.normal)
                            start.isEnabled = true
                            print("Start")
                        }
                            
                    }
                    
                }
                if checkForVictory(CROSS)
                {
                    crossesScore += 1
                    resultAlert(title: "Crosses Win!")
                }
                
                if checkForVictory(NOUGHT)
                {
                    noughtsScore += 1
                    resultAlert(title: "Noughts Win!")
                }
                
                if(fullBoard())
                {
                    resultAlert(title: "Draw")
                }
                
            }
	}
	
	func initBoard()
	{
		board.append(a1)
		board.append(a2)
		board.append(a3)
		board.append(b1)
		board.append(b2)
		board.append(b3)
		board.append(c1)
		board.append(c2)
		board.append(c3)
	}
    
   
    
    @IBAction func resetButton(_ sender: UIButton) {
        let docRef = db.collection("Game").document("Session")
        docRef.setData([ "inSession": "false" ], merge: true)
        docRef.setData([ "currentPlayer": CROSS ], merge: true)
        self.player = 0
        self.resetBoard()

        db.collection("Game").document("Session").setData([
            "a1": " ",
            "a2": " ",
            "a3": " ",
            "b1": " ",
            "b2": " ",
            "b3": " ",
            "c1": " ",
            "c2": " ",
            "c3": " "
        ],merge:true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        
       
        
                let docRef = db.collection("Game").document("Session")
                  docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
        //                let documentData = document.data().map(String.init(describing:)) ?? "nil"
        //
        //                print("Document data: \(documentData)")
                        
                        let data = document.data()
                        let inSession = data!["inSession"]! as? String ?? ""
                        if (inSession == "false")
                        {
                            self.player = 1
                            docRef.setData([ "currentPlayer": self.CROSS ], merge: true)
                            docRef.setData([ "inSession": "true" ], merge: true)
                        }
                        else if (inSession == "true")
                        {
                            self.player = 2
                        }
                       
                                
//                                print(inSession)
                        
                    } else {
                        print("Document does not exist")
                    }
                }
            
        
        
    }
    @IBAction func boardTapAction(_ sender: UIButton)
	{
        
        //check firebase
        //if blank
        //make player x
        //if full
        //make player o
//        let docRef = db.collection("Game").document("Session")
//          docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//
//                let data = document.data()
//                let current = data!["currentPlayer"]! as? String ?? ""
//                if (current == CROSS)
//                {
//                    docRef.setData([ "currentPlayer": "o" ], merge: true)
//
//                }
//                else if (current == "o")
//                {
//                    docRef.setData([ "currentPlayer": CROSS ], merge: true)
//                }
//
//
//                        print(current)
//
//            } else {
//                print("Document does not exist")
//            }
//        }
        addToBoard(sender)
		
		
//		if checkForVictory(CROSS)
//		{
//			crossesScore += 1
//			resultAlert(title: "Crosses Win!")
//		}
//
//		if checkForVictory(NOUGHT)
//		{
//			noughtsScore += 1
//			resultAlert(title: "Noughts Win!")
//		}
//
//		if(fullBoard())
//		{
//			resultAlert(title: "Draw")
//		}
	}
	
	func checkForVictory(_ s :String) -> Bool
	{
		// Horizontal Victory
		if thisSymbol(a1, s) && thisSymbol(a2, s) && thisSymbol(a3, s)
		{
			return true
		}
		if thisSymbol(b1, s) && thisSymbol(b2, s) && thisSymbol(b3, s)
		{
			return true
		}
		if thisSymbol(c1, s) && thisSymbol(c2, s) && thisSymbol(c3, s)
		{
			return true
		}
		
		// Vertical Victory
		if thisSymbol(a1, s) && thisSymbol(b1, s) && thisSymbol(c1, s)
		{
			return true
		}
		if thisSymbol(a2, s) && thisSymbol(b2, s) && thisSymbol(c2, s)
		{
			return true
		}
		if thisSymbol(a3, s) && thisSymbol(b3, s) && thisSymbol(c3, s)
		{
			return true
		}
		
		// Diagonal Victory
		if thisSymbol(a1, s) && thisSymbol(b2, s) && thisSymbol(c3, s)
		{
			return true
		}
		if thisSymbol(a3, s) && thisSymbol(b2, s) && thisSymbol(c1, s)
		{
			return true
		}
		
		return false
	}
	
	func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool
	{
		return button.title(for: .normal) == symbol
	}
	
	func resultAlert(title: String)
	{
		let message = "\nNoughts " + String(noughtsScore) + "\n\nCrosses " + String(crossesScore)
		let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
			self.resetBoard()
		}))
		self.present(ac, animated: true)
	}
	
	func resetBoard()
	{
		for button in board
		{
			button.setTitle(" ", for: .normal)
			button.isEnabled = true
		}
//		if firstTurn == Turn.Nought
//		{
//			firstTurn = Turn.Cross
////			turnLabel.text = CROSS
//		}
//        //if end session
//        //reste player status
//		else if firstTurn == Turn.Cross
//		{
//			firstTurn = Turn.Nought
////			turnLabel.text = NOUGHT
//		}
//		currentTurn = firstTurn
        
        let docRef = db.collection("Game").document("Session")
        docRef.getDocument { [self] (document, error) in
            if let document = document, document.exists {

                let data = document.data()
                let current = data!["currentPlayer"]! as? String ?? ""
                if (current == CROSS )
                {
                    turnLabel.text = CROSS
                    firstTurn = Turn.Nought
                    
                }
                else if (current == NOUGHT)
                {
                    turnLabel.text = NOUGHT
                    firstTurn = Turn.Cross
                }
               
            } else {
                print("Document does not exist")
            }
        }
        
        db.collection("Game").document("Session").setData([
            "a1": " ",
            "a2": " ",
            "a3": " ",
            "b1": " ",
            "b2": " ",
            "b3": " ",
            "c1": " ",
            "c2": " ",
            "c3": " "
        ],merge:true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
//        if (s == "end"){
//
//        }
//
	}
	
	func fullBoard() -> Bool
	{
		for button in board
		{
            print(button.title(for: .normal) as Any)
			if button.title(for: .normal) == " "
			{
				return false
			}
		}
		return true
	}
    
    
	
	func addToBoard(_ sender: UIButton)
	{
       
        
		if(sender.title(for: .normal) == " ")
		{
//            let coords = sender.tag
           
//            print(self.player)
            
            let docRef = db.collection("Game").document("Session")
            docRef.getDocument { [self] (document, error) in
                if let document = document, document.exists {

                    let data = document.data()
                    let current = data!["currentPlayer"]! as? String ?? ""
                    if (current == CROSS && self.player == 1)
                    {
                        docRef.setData([ "currentPlayer": NOUGHT ], merge: true)
                        docRef.setData([ "\(self.detectPosition(tag: sender.tag))": CROSS ], merge: true)
//                        print(sender.tag)
                        sender.setTitle(CROSS, for: .normal)
        //                currentTurn = Turn.Nought
                        turnLabel.text = NOUGHT
                        
                    }
                    else if (current == NOUGHT && self.player == 2)
                    {
                        docRef.setData([ "currentPlayer": CROSS ], merge: true)
                        docRef.setData([ "\(self.detectPosition(tag: sender.tag))": NOUGHT ], merge: true)
//                        print(sender.tag)
                        sender.setTitle(NOUGHT, for: .normal)
        //                currentTurn = Turn.Cross
                        turnLabel.text = CROSS
                    }
                   
                            
//                            print(current)
                    
                } else {
                    print("Document does not exist")
                }
            }
           
//            if(currentTurn == Turn.Nought && self.player == 2) // and currentplayer o
//			{
//
//                //write coordinates of the "Nought"
//                //currentplayer is now x
//
//                db.collection("Game").document("Session").setData([ "\(detectPosition(tag: sender.tag))": "Nought" ], merge: true)
//                db.collection("Game").document("Session").setData([ "currentPlayer": CROSS ], merge: true)
//                print(sender.tag)
//				sender.setTitle(NOUGHT, for: .normal)
////				currentTurn = Turn.Cross
//				turnLabel.text = CROSS
//			}
//			else if(currentTurn == Turn.Cross && self.player == 1) // and currentplayer x
//			{
//                //write coordinates of the "Cross"
//                //currentplayer is now o
//                db.collection("Game").document("Session").setData([ "\(detectPosition(tag: sender.tag))": "Cross" ], merge: true)
//                db.collection("Game").document("Session").setData([ "currentPlayer": NOUGHT ], merge: true)
//
//
//                print(sender.tag)
//				sender.setTitle(CROSS, for: .normal)
////				currentTurn = Turn.Nought
//				turnLabel.text = NOUGHT
//			}
			sender.isEnabled = false
		}
	}
    
    func detectPosition(tag: Int) -> String{
        switch (tag){
        case (1): return "a1"
        case (2): return "a2"
        case (3): return "a3"

        case (4): return "b1"
        case (5): return "b2"
        case (6): return "b3"

        case (7): return "c1"
        case (8): return "c2"
        case (9): return "c3"
        default:
            return "error"
        }
    }
    
	
}

