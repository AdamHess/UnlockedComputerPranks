#Lock Your Computers Damn it!

A while ago I heard a story of a company that would change a whole bunch of setting from your computer if you walked away without locking it. 

In true fun fashion I implemented a proof of concept project (its dirty code I know) to slowly improve my powershell chops.

This will change the background to one of many memes of nick cage (/r/onetruegod) and have a mouse cursor to match it. 

Also this is intended to be loaded up on a flash drive with equally commedic effect on the icon and display name. 


#Getting Started

1. Victims computer must have the execution policy allow unsigned scripts (or just unrestricted)
2. Run the Prank.ps1 file  
3. Run the UndoPrank.ps1 file

#Victims 

This is ment to be a light hearted work prank. You can easily undo the damage (if you can get your mouse to click correctly) by opening the UndoWackyChanges folder that appears on your desktop.

Simply run the UndoPrank.Ps1 file and everything should go back to normal. 

now, what if everything doesnt? 

Well Firstly, I'm sorry!

But you'll find in teh UndoWackyChanges folder a copy of your original desktop background and mouse cursor. Both of which should be fairly easy to fixup! 

Deleted the folder?

No worries, a second backup was made on your pranksters flashdrive (they have a heart afterall) 
Ask them to check your Undo directory with your username and PC name labeling the background image and cursor (though honestly, who changes their cursor?)

#Future thoughts 

Change the login/logoff/lock windows sounds (hence the other files.)

Offer Mulitple absurd background image themes (/r/spacedicks for the less mature) or maybe even pull a random image from some subreddits. 

Possible change this to a C# application so execution policy doesnt need to be changed. 