# basic ideas ....


At the next level of detail, to save memory and makes the display easier, 
I would convert the coordinates (latitude and longitude as Doubles) of each point (Pn)
 to integer metres south and east from the start point (P0) with something like (this isn't MC):

Pn.x = (Pn.lon -P0.lon)*cos(P0.lat)*111120 (.toNumber())
Pn.y = (P0.lat - Pn.lat)*111120 (.toNumber())

Where 111120 is the number of metres in a degree of latitude 
(60 minutes/degree, 1 Nautical Mile (nm) per minute x 1852 metres/nm ) and
cos(P0.lat) is used to accommodate the sphericity of the globe.
 It' ain't precise, but works fine for tracks up to a couple of hundred km.
Now you have coordinates that you can scale to fit the screen.

Screen scrolling
This feature is provided to assist in the wet when the touch screen doesn't work well, to provide you with access to all the screens without any touching.
It kicks in after detecting no user input for 20 seconds.
Screen scrolling is now off by default.
You can change the default behaviour in Settings.


Avoir un dark mode avec inversion des couleurs
Avoir un mode le quiz avec juste la couche start qui fonctionne je suis un boulet in love mode qui répond juste à la touche start
Et après le on t'appeler le start qui démarre au qui arrête le le recording

Pour le wind intelligence on part sur la touche start qui fixe le le bon courant peut-être le le prevnext qui a juste
Et pourquoi pas un système qui permettent de fixer la vitesse aussi

VMG: 

vent ONON 292
cap 315 vit 5.9 kn

cap ok verif avec tactic
https://github.com/Rodemfr/MicronetToNMEA
https://www.hisse-et-oh.com/sailing/decodage-du-protocole-micronet-et-envoi-a-qtvlm-et-opencpn

https://forums.ybw.com/index.php?threads/raymarines-micronet.539500/

default wpts
Latitude	Longitude	Name
51.071944	2.354444	sirene
51.060005	2.370096	jaguar
51.071389	2.361944	urtigua
51.066111	2.400556	Sile1
51.062222	2.390278	Sile0
51.067778	2.385000	E1
51.072500	2.371389	E2
