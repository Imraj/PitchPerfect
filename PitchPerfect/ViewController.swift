//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Apple on 15/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var RecordAudio: UIButton!
    @IBOutlet weak var stopRecording: UIButton!

    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecording.isEnabled = false
    }
    
    
    @IBAction func recordAudio(_ sender: Any) {
        
        print("record button was clicked")
        recordingLabel.text = "Recording in Progress"
        
        RecordAudio.isEnabled = false
        stopRecording.isEnabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath,recordingName]
        let filePath = URL(string:pathArray.joined(separator: "/"))
        print(filePath)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    
    
    @IBAction func stopRecording(_ sender: Any) {
        
        print("Stop recording button was clicked")
        recordingLabel.text = "Tap to Record"
        
        RecordAudio.isEnabled = true
        stopRecording.isEnabled = false
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //print ("finish recording")
        if(flag){
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("error saving recording")
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecording" )
        {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
            
        }
    }
    
}

