//
//  ViewController.swift
//  Swift_MemoryGame
//
//  Created by Logan McKinzie on 6/15/15.
//  Copyright (c) 2015 Logan McKinzie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // OUTLETS
    // Best Outlets
    @IBOutlet weak var bestMoves: UILabel!
    @IBOutlet weak var bestTime: UILabel!
    
    // Current Outlets
    @IBOutlet weak var moves: UILabel!
    @IBOutlet weak var time: UILabel!
    
    // Play Button Outlet
    @IBOutlet weak var playButton: UIButton!
    
    // Box Views Outlet
    @IBOutlet var boxes: [UIView]!
    
    // Box ImageViews Outlet
    @IBOutlet var boxImages: [UIImageView]!
    
    // Outlets for How to Play and Victory Views
    @IBOutlet weak var howToPlay: UIView!
    @IBOutlet weak var victory: UIView!
    
    // Outlets used to customize victory message on victory view.
    @IBOutlet weak var victoryTime: UILabel!
    @IBOutlet weak var victoryMoves: UILabel!
    @IBOutlet weak var victoryStats: UILabel!
    
    // Array of selected boxes.
    var selectedBoxes: [UIView] = []
    
    // Time Counter
    var counter = 1
    
    // Move Counter
    var movesCounter = 0
    
    // Best Moves Count
    var movesBest = 100000
    
    // Best Time Count
    var timeBest = 100000
    
    // Box Counter, used to detect when the user has won.
    var boxCounter = 0
    
    // Timer
    var timer = NSTimer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // These lines of code create tap gesture recognizers and assign them to the how to play and victory views. They are used to hide the views when the user taps them.
        var tapGesture1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "TapGestureRecognizedHTP:")
        var tapGesture2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "TapGestureRecognizedV:")
        
        howToPlay.addGestureRecognizer(tapGesture1)
        victory.addGestureRecognizer(tapGesture2)
        
        // This disables the play button so that the user cannot tap it until the how to play view is tapped, preventing the player from starting the game with the how to play view in the way.
        playButton.enabled = false
        
    }
    
    // Function used to re-hide images when the user does not get a match.
    func hideBoxes () {
        for box in selectedBoxes {
            box.layer.borderWidth = 0
            box.backgroundColor = UIColor.blackColor()
            (box.subviews[0] as! UIImageView).hidden = true
        }
        
        // Iterates the moves counter, showing the user that they have made a move.
        movesCounter++
        moves.text = "Moves: \(movesCounter)"
        
        // Removes the selected boxes from the selected boxes array, allowing the user to start selecting more boxes.
        selectedBoxes.removeAll(keepCapacity: false)
        
        // Renables user interaction.
        view.userInteractionEnabled = true
    }
    
    // Function used to hide boxes when the user gets a match.
    func removeBoxes () {
        for box in selectedBoxes {
            box.hidden = true
        }
        
        // This iterates the box counter backwards by 2, effectively removing the 2 matched boxes from the count of boxes.
        boxCounter--
        boxCounter--
        
        movesCounter++
        moves.text = "Moves: \(movesCounter)"
        
        selectedBoxes.removeAll(keepCapacity: false)
        
        // This checks for the victory condition, which is if the amount of boxes is 0, the user has won. A couple of things happen now.
        if boxCounter == 0 {
            
            // This stops the game timer.
            timer.invalidate()
            
            // Here we check if the user beat their previous best move count, and change the victory text accordingly.
            // None of this saves since we are not using core data.
            if movesBest > movesCounter {
                movesBest = movesCounter
                victoryMoves.text = "You beat your best moves!"
                bestMoves.text = "Best Moves: \(movesBest)"
            } else {
                victoryMoves.text = "You did not beat your best moves."
            }
            
            // Same as above, but here we check against the best time.
            if timeBest > counter {
                
                // Since there is a one second delay in updating the counter when the timer starts, the counter is actually one second ahead of the real time. So we need to get rid of that phantom second.
                timeBest = counter - 1
                victoryTime.text = "You beat your best time!"
                bestTime.text = "Best Time: \(timeBest)"
            } else {
                victoryTime.text = "You did not beat your best time."
            }
            
            // We display the victory view to the user.
            victory.hidden = false
            
            // Inserts the user's stats into the victory view.
            victoryStats.text = "You finished in \(counter - 1) seconds with \(movesCounter) moves."
            
            
        }
        
        // Whether or not the user won, we still have to renable user interaction after two boxes have been matched.
        view.userInteractionEnabled = true
    }
    
    // Function to hide the how to play view when tapped.
    func TapGestureRecognizedHTP (sender: UITapGestureRecognizer) {
        howToPlay.hidden = true
        playButton.enabled = true
    }
    
    // Function to hide the victory view when tapped.
    func TapGestureRecognizedV (sender: UITapGestureRecognizer) {
        victory.hidden = true
        playButton.hidden = false
    }
    
    // Tap Gesture Function for boxes.
    func TapGestureRecognized (sender: UITapGestureRecognizer) {
        
        
        // There are a couple of checks we have to do here. The first is to check if the user has selected more than 0 boxes.
        if selectedBoxes.count > 0 {
            
            // If they have, we need to make sure they haven't selected the same box twice, by checking the descriptions. If they haven't, we add that box to the array of selected boxes. If they have, we just deselect that box.
            if sender.view?.description != selectedBoxes[0].description {
                sender.view?.layer.borderColor = UIColor.blackColor().CGColor
                sender.view?.layer.borderWidth = 3
                sender.view?.backgroundColor = UIColor.whiteColor()
                selectedBoxes.append(sender.view!)
                (sender.view?.subviews[0] as! UIImageView).hidden = false
            } else {
                hideBoxes()
            }
            
            // If there isn't more than one box in the the array, we have to remove the description check or else that array index will be nil and will cause a crash. We still add the selected box to the array.
        } else {
            sender.view?.layer.borderColor = UIColor.blackColor().CGColor
            sender.view?.layer.borderWidth = 3
            sender.view?.backgroundColor = UIColor.whiteColor()
            selectedBoxes.append(sender.view!)
            (sender.view?.subviews[0] as! UIImageView).hidden = false
        }
        
        // If at this point, the array of selected boxes is equal to 2, then we know we need to determine if the boxes match or not.
        if selectedBoxes.count == 2 {
            
            // To do this, we check if the image in the first box is equal to the image in the second box.
            if (selectedBoxes[0].subviews[0] as! UIImageView).image == (selectedBoxes[1].subviews[0] as! UIImageView).image {
                
                sender.view?.layer.borderColor = UIColor.blackColor().CGColor
                sender.view?.layer.borderWidth = 3
                sender.view?.backgroundColor = UIColor.whiteColor()
                (sender.view?.subviews[0] as! UIImageView).hidden = false
                
                // If they are equal, we disable user interaction so that they cannot go clicking on other boxes willy nilly. Then we start a timer for half a second. The main purpose of this is so that before the boxes disappear, the user can see what was in the second box, whether it was a match or not. The timer runs the removeBoxes function and then ends.
                view.userInteractionEnabled = false
                var timer3 = NSTimer()
                timer3 = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "removeBoxes", userInfo: nil, repeats: false)
                
                // If the images aren't equal, we still run a timer to let the user see what was in the other box.
            } else {
                
                sender.view?.layer.borderColor = UIColor.blackColor().CGColor
                sender.view?.layer.borderWidth = 3
                sender.view?.backgroundColor = UIColor.whiteColor()
                (sender.view?.subviews[0] as! UIImageView).hidden = false
                
                view.userInteractionEnabled = false
                var timer2 = NSTimer()
                timer2 = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "hideBoxes", userInfo: nil, repeats: false)
            }
            
        }
        
    }
    
    // Time Update Function, updates the timer in the bottom right of the screen.
    func updateTime () {
        time.text = "Time: \(String(counter++))"
    }
    
    // Play Button Action, this action starts the game.
    @IBAction func playGame(sender: UIButton) {
        
        // First we add tap gestures to every box.
        for box in boxes {
            var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "TapGestureRecognized:")
            
            box.addGestureRecognizer(tapGesture)
        }
        
        // Then we make sure the moves counter starts at zero.
        movesCounter = 0
        moves.text = "Moves: 0"
        
        // Here we start a timer that tracks the user's current time played. This resets every time the play button is pressed.
        counter = 1
        time.text = "Time: 0"
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        
        // We hide the play button so the user can't reclick it.
        playButton.hidden = true
        
        // This checks if a high numbered box is uninstalled. Since it is only installed on the iPad version, this basically detects if we are on an iPhone or iPad.
        if boxes[25].window == nil {
            
            // iPhone Version
            // Array of 10 images, repeated twice for matches.
            var images: [String] = ["banana", "bone", "corn", "garlic", "grape", "lemon", "mushroom", "pineapple", "pork", "pumpkin", "banana", "bone", "corn", "garlic", "grape", "lemon", "mushroom", "pineapple", "pork", "pumpkin"]
            
            for box in boxes {
                box.layer.borderWidth = 0
                box.backgroundColor = UIColor.blackColor()
                box.hidden = false
            }
            
            // Loops through boxes on screen in order. Each box randomly takes an image from the images array, removing it from the array. When the array is empty, the process stops. We don't need to alter this for the iPhone version since the array will run out before the loop reaches uninstalled boxes.
            for index in boxImages {
                if images.count > 0 {
                    boxCounter++
                    var random = arc4random_uniform(UInt32(images.count))
                    index.image = UIImage(named: images.removeAtIndex(Int(random)))
                    index.hidden = true
                } else {
                    return
                }
            }
            
        } else {
            
            // iPad Version
            // Array of 15 images, repeated twice for matches.
            var images: [String] = ["banana", "bone", "bulb", "corn", "cylinder", "garlic", "grape", "lemon", "mushroom", "pineapple", "pork", "pumpkin", "square", "tree", "triangle", "banana", "bone", "bulb", "corn", "cylinder", "garlic", "grape", "lemon", "mushroom", "pineapple", "pork", "pumpkin", "square", "tree", "triangle"]
            
            for box in boxes {
                box.layer.borderWidth = 0
                box.backgroundColor = UIColor.blackColor()
                box.hidden = false
            }
            
            // Loops through boxes on screen in order. Each box takes an image from the images array, removing it from the array. When the array is empty, the process stops.
            for index in boxImages {
                if images.count > 0 {
                    boxCounter++
                    var random = arc4random_uniform(UInt32(images.count))
                    index.image = UIImage(named: images.removeAtIndex(Int(random)))
                    index.hidden = true
                } else {
                    return
                }
            }
        }
    }
}

