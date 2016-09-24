[REST Green Walk]
=================

**Download for [iPhone] or [iPad].**

<a href="https://vimeo.com/141249918"><img src="https://raw.githubusercontent.com/Alhadis/REST-GreenWalk/static/watch-video.png" width="512" /></a>

This is an iOS app I developed in late 2010 for Swinburne TAFE, when I was still new to serious programming. Consequently, none of the original project files were tracked in version control; this repository's history has been synthesised using timestamps of `rar` archives taken off an old CD-R.

<img src="https://raw.githubusercontent.com/Alhadis/REST-GreenWalk/static/figure-1.jpg" align="left" width="256" />
#### Background
I was commissioned to model, texture, render and animate a realistic 3D flythrough of the campus grounds to showcase sustainability-related features that had been installed earlier that year. These included solar panels, hydroponic gardens, solar-powered hot water systems, drainage systems, and others.

These installments were accompanied by podium signs describing their operation, and how they benefited the environment. The signs themselves were meant to be read sequentially, taking visitors across the campus grounds between each landmark. The app's purpose was to deliver the experience of walking through the campus, seeing and reading about each feature.


<img src="https://raw.githubusercontent.com/Alhadis/REST-GreenWalk/static/figure-2.jpg" align="right" width="256" />
#### Development
Aside from graphical duties, I was also tasked with learning XCode and Objective-C, neither of which I'd never heard of prior to the project. Programming was handled in parallel to  3D duties, often while rendering. Two different versions of the app were produced; one for [iPad][1], and another for iPhone. Both used a different version of the full-res animation, scaled appropriately.

[1]: https://github.com/Alhadis/REST-GreenWalk/tree/ipad

Needless to say, the total time to render a 4.5-minute long iPad-sized animation was far from trivial. A grand total of 5 months (including compositing, masking and additional tracking) was spent before the compiled animation was ready to be dropped into the fledgling iOS app. Remaining development lasted until November, spanning a full year's worth of work.

Modelling, texturing and animation was done with 3D Studio Max. Rendering was handled in individual segments using V-Ray, running on a homebuilt render farm. Adobe After Effects was used to composite the raw footage.

The animation was rendered in square ratio to accommodate for devices being held in both portrait and landscape orientation. One of the programming challenges was animating the video based on the device's orientation so the focal point of the video was always in sight. This added animation was also handled in After Effects, with keyframes exported to plists using JavaScript.


#### Copyright
Copyright 2010-2011 Swinburne University. All rights reserved.


[Referenced Links]:_____________________________________________________________
[REST Green Walk]: https://vimeo.com/141249918
[iPhone]:          https://itunes.apple.com/au/app/id478687882
[iPad]:            https://itunes.apple.com/au/app/green-walk-hd/id479502843
