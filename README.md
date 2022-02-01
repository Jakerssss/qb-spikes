# qb-spikes
Usable Item Spike Strip

#Config.Amount = 3 --= how many spikes will be spawned, ie you have 3 in your pockets it will place 3 in a line. 

#Use
Face the direction you want the spike strips to spawn and use item.

#Pickup
Face the spikes and look at the object with your third eye (qb-target)

# You must add the item to your shared.lua or item.lua
['policespikes'] 			 	 	 = {['name'] = 'policespikes', 			  			['label'] = 'Spike Strip', 				['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'policespikes.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'Spikes to deflate tires'},

#Add the Img to 
[qb][?]-inventory\html\images
