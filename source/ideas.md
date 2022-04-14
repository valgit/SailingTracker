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
