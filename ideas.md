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

function transformToPixels(lat, lon){
        var westLongitude = boundingBox[1].toDegrees()[1]; 
        var eastLongitude = boundingBox[0].toDegrees()[1];
        var northLatitude = boundingBox[1].toDegrees()[0];
        var southLatitude = boundingBox[0].toDegrees()[0];
        var longitudeDiff = eastLongitude - westLongitude;
        var latitudeDiff = northLatitude - southLatitude;
        var xPixel = (((eastLongitude - lon) / (longitudeDiff).toDouble()) * DISPLAY_WIDTH).toNumber();
        var yPixel = (((northLatitude - lat) / (latitudeDiff).toDouble()) * DISPLAY_HEIGHT).toNumber();
        return [xPixel - 3, yPixel + 20]; //figured these numbers to somehow fit the space
    }



    // calculate max and min values for lons and lats
var lonMax = -180.0;
var lonMin =  180.0;
var latMax =  -90.0;
var latMin =   90.0;
for(i=0; i < track.size(), i++) {
    lonMax = (lonMax > lon[i]) ? lonMax : lon[i];
    lonMin = (lonMin < lon[i]) ? lonMax : lon[i];
    latMax = (latMax > lat[i]) ? latMax : lat[i];
    latMin = (latMin < lat[i]) ? latMax : lat[i];
}

// scale the geographical size to the display size
var scaleX = dc.getWidth() / (lonMax - lonMin);
var scaleY = dc.getHeight() / (latMax - latMin);
var scaleXY = (scaleX < scaleY) ? scaleX : scaleY;

for(i=0; i < track.size(), i++) {
    // calculate point locations in pixels
    var pixelsLon = (lon[i+1] - lon[i]) * scaleXY;
    var pixelsLat = (lat[i+1] - lat[i]) * scaleXY;

    // adjust point locations to a reference point
    var displayX = pixelsLon + pixelsXRef;
    var displayY = pixelsLat + pixelsYRef;

    // draw points
    dc.setColor(...);
	dc.fillCircle(displayX, displayY, 2);
}

* Screen scrolling
This feature is provided to assist in the wet when the touch screen doesn't work well, to provide you with access to all the screens without any touching.
It kicks in after detecting no user input for 20 seconds.
Screen scrolling is now off by default.
You can change the default behaviour in Settings.


* Avoir un dark mode avec inversion des couleurs
Avoir un mode le quiz avec juste la couche start qui fonctionne je suis un boulet in love mode qui répond juste à la touche start
Et après le on t'appeler le start qui démarre au qui arrête le le recording

* Pour le wind intelligence on part sur la touche start qui fixe le le bon courant peut-être le le prevnext qui a juste
Et pourquoi pas un système qui permettent de fixer la vitesse aussi

* utiliser les lap/touch screen ? pour marqué le start ? et chronometre mode ?

Note : peut-être que certains mode ne sotn que affichage et le reste continue de tourné, sans que ça s'inetrrompe.
Note2 : voir pour utiliser le heading pour definier tack/gybe ?

VMG: 

vent ONON 292
cap 315 vit 5.9 kn

cap ok verif avec tactic
https://github.com/Rodemfr/MicronetToNMEA
https://www.hisse-et-oh.com/sailing/decodage-du-protocole-micronet-et-envoi-a-qtvlm-et-opencpn


5 buttons :
    Top Left – Press to toggle the backlight. Press and hold to access the controls menu.
    Middle Left – Press for a previous/up behavior. Press and hold for a menu behavior.
    Bottom Left – Press for a next/down behavior.
    Top Right – Press for a select behavior. Commonly used for the start/stop action on Garmin activities.
    Bottom Right – Press for a back behavior.

1 button
    Swiping left to right will perform the previous/up behavior.
    Swiping right to left will perform the next/down behavior.
    Menus can be dragged and flicked with the touch screen.
    Tapping on a screen item performs a select behavior.
    Tapping the on-screen back button performs the back action.
    Tapping the on-screen hamburger menu performs the menu action.


var pair = Application.Storage.getValue(“points”);
if(pair==null){pair = new [0];}

var pos = Position.getInfo().position;
pos = pos.toDegrees();

lat = pos[0];
lon = pos[1];
var CurrPair = [lat,lon];
pair.add(CurrPair)

Me = [240/2, 240/2];

function transformCoordinates(lat, lon){
var pixelsLong = (120 - lon) * (4 / screenWidthPixels);

var pixelsHeight = (lat - 120) * (4 / screenHeightPixels);

var x = Me[0] - pixelsLong;
var y = Me[1] - pixelsLat;

return [x,y];}

function onUpdate;

if (track! = null){

dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

for(var i=0; i < track.size(); i=i+2){
var pointA = transformCoordinates(track[i], track[i+1]);
var pointB = transformCoordinates(track[i+2], track[i+3]);

dc.setPenWidth(8);

dc.drawPoint(pointA[0], pointA[1]);

dc.setPenWidth(3);

dc.drawLine(pointA[0], pointA[1] , pointB[0], pointB[1] );

for(i=0;i<track.size();i=i+2) {
    thisLat=track[i];
    thisLon=track[i+1];
    //do whatever
}


const EARTHRADIUS = 6371000.0d;  // m
var scaleDistDeg = (EARTHRADIUS * Math.PI) / 180.0d;  // m/deg

// define maximum trace length in m to display
// either with hard coding or by user settings
// this means only the last 1000m are inside the display 
// the other points are outside and therefore not visible
const totalTraceLen = 1000.0;
var totalTraceDeg = traceLen / scaleDistDeg;  // deg/1000m

var lonMax = totalTraceDeg;
var lonMin = 0.0d;
var latMax = totalTraceDeg;
var latMin = 0.0d;

//--- old code equals to last comment ---

// scale the geographical size to the display size
var scaleX = dc.getWidth() / (lonMax - lonMin);
var scaleY = dc.getHeight() / (latMax - latMin);
var scaleXY = (scaleX < scaleY) ? scaleX : scaleY;

for(i=0; i < track.size(), i++) {
    // calculate point locations in pixels
    var pixelsLon = (lon[i+1] - lon[i]) * scaleXY;
    var pixelsLat = (lat[i+1] - lat[i]) * scaleXY;

    // adjust point locations to a reference point
    var displayX = pixelsLon + pixelsXRef;
    var displayY = pixelsLat + pixelsYRef;

    // draw points
    dc.setColor(...);
	dc.fillCircle(displayX, displayY, 2);
}

// add aditional lon/lats and execute the previous for() loop
...

if(lat != null){
var lonMax = -180.0;
var lonMin = 180.0;
var latMax = -90.0;
var latMin = 90.0;
for(var i=0; i < lat.size(); i++) {
lonMax = (lonMax > lon[i]) ? lonMax : lon[i];
lonMin = (lonMin < lon[i]) ? lonMin : lon[i];
latMax = (latMax > lat[i]) ? latMax : lat[i];
latMin = (latMin < lat[i]) ? latMin : lat[i];
System.println("lonmax = " + lonMax);
System.println("latmax = " + latMax);
System.println("lonmin = " + lonMin);
System.println("latmin = " + latMin);
}

var scaleX = dc.getWidth() / (lonMax - lonMin);
var scaleY = dc.getHeight() / (latMax - latMin);
var scaleXY = (scaleX < scaleY) ? scaleX : scaleY;

dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);
dc.setPenWidth(4);
for(var i=0; i < (lat.size() - 2); i+=2){
var pixelsLon = (lon[i+1] - lon[i]) * scaleXY;
var pixelsLat = (lat[i+1] - lat[i]) * scaleXY;

var displayX = pixelsLon + 120; // screenwidth
var displayY = pixelsLat + 120; //screenheight

dc.fillCircle(displayX, displayY, 3);
if (i == 0) {
var displayXOld = displayX;
var displayYOld = displayY;

} else {
var displayXOld = displayX;
var displayYOld = displayY;
System.println("dxold and dyold" + displayXOld + displayYOld);
System.println("dx and dy" + displayX + displayY);
dc.drawLine(displayXOld, displayYOld, displayX, displayY);
}
}}
