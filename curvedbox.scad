//============================================================
// OpenSCAD Project
//
// VincentD
//============================================================

/*
    Simple box
    Improve yourself to do what you want.
    
    All plate are symetrical.

    Text must be inside the box.
    Except for the Top Box.
    ! Take care of that
    
    If you don't want slot between sides
    ! Comment all the links that refeer them !    

*/

//------------------------------------------------------------
// Parameters
//------------------------------------------------------------
$fn = 150;  // OpenScad

// Define the size of the box
xSize = 80;
ySize = 80;
zSize = 80;

// thickness of the material used !!!
thickness = 3 ;

// Size of the 1st part of the slot for mounting the box !!!
// the size of the other part depand of the ysize used
// Take care with the min value of
// xsize, ysize or zsize and thickness!
tabaSize = 10;

// Text to help for assembly and orientation
ft = "Stencil";
//ft = "Courrier";


//------------------------------------------------------------
// For symetrical disposition to match everywhere on the box
// Slots are centred
//------------------------------------------------------------
// xsize calculation
cx = (tabaSize <= xSize/2 ? floor((xSize/2)/tabaSize) : ( tabaSize>=xSize-2*thickness ? 0 : 1 ) );
nx = cx+1;
tabbSizeX = ( cx!=0 ? (xSize-(cx*tabaSize))/nx : 0 );

// ysize calculation
cy = (tabaSize <= ySize/2 ? floor((ySize/2)/tabaSize) : ( tabaSize>=ySize-2*thickness ? 0 : 1 ) );
ny = cy+1;
tabbSizeY = ( cy!=0 ? (ySize-(cy*tabaSize))/ny : 0 );

// zsize calculation
cz = (tabaSize <= zSize/2 ? floor((zSize/2)/tabaSize) : ( tabaSize>=zSize-2*thickness ? 0 : 1 ) );
nz = cz+1;
tabbSizeZ = ( cz!=0 ? (zSize-(cz*tabaSize))/nz : 0 );


//------------------------------------------------------------
// Start
// Choose the view by comment and uncomment
//------------------------------------------------------------

// Need to know if it is possible or not to build the box
if ( tabbSizeX !=0 && tabbSizeY !=0 && tabbSizeZ !=0 && tabaSize>thickness)
{
    echo("\n\tBuilding the box is Possible.\n");
//    FlatView();
    MountView();
}
else echo("\n\tBuilding the box is NOT Possible.\n");


//------------------------------------------------------------
// Linear extrude and move to mount the box
// Transparency to see inside
//------------------------------------------------------------
module MountView()
{
    // center the box
    translate([-xSize/2,-ySize/2,-zSize/2])
    {
        // Bottom
        color("red", 0.5)
            translate([0,0,12])
                linear_extrude(height=thickness)
                    BoxBottom();

/*
        // Top
        color("red", 0.5)
            translate([0,0,zSize-thickness])
                linear_extrude(height=thickness)
                    BoxTop();
*/
        
        // Back
        color("grey", 0.5)
            translate([thickness,0,0])
                rotate([0,-90,0])
                    linear_extrude(height=thickness)
                        BoxBack();

        // Front
        color("grey", 0.5)
            translate([xSize,0,0])
                rotate([0,-90,0])
                    linear_extrude(height=thickness)
                        BoxFront();

        // Left
        color("yellow", 0.5)
            translate([xSize, 0,0])
                rotate([90,0,180])
                    linear_extrude(height=thickness)
                        BoxLeft();

        // Right
        color("yellow", 0.5)
            translate([0,ySize,0])
                rotate([90,0,0])
                    linear_extrude(height=thickness)
                        BoxRight();
    }
}

//------------------------------------------------------------
// Flat View of the box
// Comment as you wish to generate DXF or SVG files
//------------------------------------------------------------
module FlatView()
{
    // Bottom
    BoxBottom();

    // Top
//    translate([-zSize-xSize-2,0,0])
//        BoxTop();

    // Back
    translate([-zSize-1,0,0])
        BoxBack();

    // Front
    translate([xSize+1,0,0])
        BoxFront();

    // Left
    translate([xSize,-1,0]) 
        rotate([0,0,180])
            BoxLeft();

    // Right
    translate([0,ySize+1,0])
        BoxRight();
}

//------------------------------------------------------------
// Top, Bottom : use [x,y]
//------------------------------------------------------------
module BoxTop()
{
    difference()
    {
        square([xSize,ySize]);

        for ( i = [tabBysizeY : tabBysizeY+tabaSize : y-tabaSize] )
        {
            // Top Bottom - Back link
            translate([0,i,0])
            square([thickness, E]);
            
            // Top Bottom - Front Link
            translate([x-thickness,i,0])
            square([thickness, E]);
        }
        
        //  (x)
        /*
        for ( i = [Ex : Ex+E : x-E] )
        {
            // Top Bottom - Left Link
            translate([i,0,0])
            square([E, thickness]);
            
            // Top Bottom - Right Link
            translate([i,y-thickness,0])
            square([E, thickness]);
        }
        */
        
        // Text inside for orientation
        translate([x/2,y/2,0]) rotate([0,0,90])
        text("Top", size=5, valign="center", halign="center", font=ft);
    }
}

module BoxBottom()
{
	difference()
    {
        square([xSize,ySize]);

        // tabs on y axis
        onetabspaceY = tabaSize + tabbSizeY;
        alltabsspaceY = ySize - (thickness * 2);
        tabscountY = floor(alltabsspaceY / onetabspaceY);
        bufferY = ((ySize - (tabscountY * onetabspaceY)) / 2) + (tabbSizeY/2);

        translate([0, 0, 0]) 
            square([thickness, bufferY]);
        for ( i = [bufferY + tabaSize: onetabspaceY: ySize - bufferY] )
        {
            translate([0, i, 0]) 
                square([thickness, tabbSizeY]);
        }
      
        translate([xSize-thickness, 0, 0]) 
            square([thickness, bufferY]);
        for ( i = [bufferY + tabaSize: onetabspaceY: ySize - bufferY] )
        {
            translate([xSize-thickness, i, 0]) 
                square([thickness, tabbSizeY]);
        }

        // tabs on x axis
        onetabspaceX = tabaSize + tabbSizeX;
        alltabsspaceX = xSize - (thickness * 2);
        tabscountX = floor(alltabsspaceX / onetabspaceX);
        bufferX = ((xSize - (tabscountX * onetabspaceX)) / 2) + (tabbSizeX/2);

        translate([0, 0, 0]) 
            square([bufferX, thickness]);
        for ( i = [bufferX + tabaSize: onetabspaceX: xSize - bufferX] )
        {
            translate([i, 0, 0]) 
                square([tabbSizeX, thickness]);
        }

        translate([0, ySize-thickness, 0]) 
            square([bufferX, thickness]);
        for ( i = [bufferX + tabaSize: onetabspaceX: xSize - bufferX] )
        {
            translate([i, ySize-thickness, 0]) 
                square([tabbSizeX, thickness]);
        }
        
        // Text inside for orientation
        translate([xSize/2,ySize/2,0]) 
            rotate([0,-180,90])
                text("Bottom", size=5, valign="center", halign="center", font=ft);
    }
}

module BoxBack()
{
	difference()
    {
        square([zSize,ySize]);

        // the curved foot
        translate([0, ySize/2, 0]) 
            resize([18, ySize - (thickness*6)]) 
                circle(1);

        // bottom tabs
        onetabspaceY = tabaSize + tabbSizeY;
        alltabsspaceY = ySize - (thickness * 2);
        tabscountY = floor(alltabsspaceY / onetabspaceY);
        bufferY = ((ySize - (tabscountY * onetabspaceY)) / 2) + (tabbSizeY/2);
        for ( i = [bufferY: onetabspaceY: ySize - bufferY] )
        {
            translate([12, i, 0])
                square([thickness, tabaSize]);
        }

        // left tabs
        for ( i = [0 : tabbSizeZ+tabaSize : zSize] )
        {
            translate([i,0,0]) 
                square([tabbSizeZ, thickness]);
        }
        
        // right tabs
        for ( i = [0 : tabbSizeZ+tabaSize : zSize] )
        {
            translate([i,ySize-thickness,0]) 
                square([tabbSizeZ, thickness]);
        }
        
        translate([zSize/2,ySize/2,0]) 
            rotate([0,0,-90])
                text("Back", size=5, valign="center", halign="center", font=ft);        
    }
}

module BoxFront()
{
	difference()
    {
        square([zSize,ySize]);
     
        // the curved foot
        translate([0, ySize/2, 0]) 
            resize([18, ySize - (thickness*6)]) 
                circle(1);
        
        // bottom tabs
        onetabspace = tabaSize + tabbSizeY;
        alltabsspace = ySize - (thickness * 2);
        tabscount = floor(alltabsspace / onetabspace);
        buffer = ((ySize - (tabscount * onetabspace)) / 2) + (tabbSizeY/2);
        for ( i = [buffer: onetabspace: ySize - buffer] )
        {
            translate([12, i, 0])
                square([thickness, tabaSize]);
        }

        // left tabs
        for ( i = [0 : tabbSizeZ+tabaSize : zSize] )
        {
            translate([i,0,0]) 
                square([tabbSizeZ, thickness]);
        }
        
        // right tabs
        for ( i = [0 : tabbSizeZ+tabaSize : zSize] )
        {
            translate([i,ySize-thickness,0]) 
                square([tabbSizeZ, thickness]);
        }
        
        translate([zSize/2,ySize/2,0]) 
            rotate([0,-180,-90])
                text("Front", size=5, valign="center", halign="center", font=ft);        
    }
}

module BoxLeft()
{
    // modify as you wish
    difference()
    {
        square([xSize,zSize]);
     
        // the curved foot
        translate([xSize/2, 0, 0]) 
            resize([xSize - (thickness*6), 18]) 
                circle(1);
        
        // bottom tabs
        onetabspaceX = tabaSize + tabbSizeX;
        alltabsspaceX = xSize - (thickness * 2);
        tabscountX = floor(alltabsspaceX / onetabspaceX);
        bufferX = ((xSize - (tabscountX * onetabspaceX)) / 2) + (tabbSizeX/2);
        for ( i = [bufferX: onetabspaceX: xSize - bufferX] )
        {
            translate([i, 12, 0])
                square([tabaSize, thickness]);
        }

        // left tabs
        for ( i = [tabbSizeZ : tabbSizeZ+tabaSize: zSize-tabaSize] )
        {
            translate([0,i,0])
                square([thickness, tabaSize]);
        }
        
        // right tabs
        for ( i = [tabbSizeZ : tabbSizeZ+tabaSize : zSize-tabaSize] )
        {
            translate([xSize-thickness,i,0])
                square([thickness, tabaSize]);
        }
        
        // Text inside for orientation
        translate([xSize/2,zSize/2,0])
            rotate([0,-180,0])
                text("Left", size=5, valign="center", halign="center", font=ft);

    }
}

module BoxRight()
{
    // modify as you wish
    difference()
    {
        square([xSize,zSize]);
     
        // the curved foot
        translate([xSize/2, 0, 0]) 
            resize([xSize - (thickness*6), 18]) 
                circle(1);
        
        // bottom tabs
        onetabspaceX = tabaSize + tabbSizeX;
        alltabsspaceX = xSize - (thickness * 2);
        tabscountX = floor(alltabsspaceX / onetabspaceX);
        bufferX = ((xSize - (tabscountX * onetabspaceX)) / 2) + (tabbSizeX/2);
        for ( i = [bufferX: onetabspaceX: xSize - bufferX] )
        {
            translate([i, 12, 0])
                square([tabaSize, thickness]);
        }

        // left tabs
        for ( i = [tabbSizeZ : tabbSizeZ+tabaSize: zSize-tabaSize] )
        {
            translate([0,i,0])
                square([thickness, tabaSize]);
        }
        
        // right tabs
        for ( i = [tabbSizeZ : tabbSizeZ+tabaSize : zSize-tabaSize] )
        {
            translate([xSize-thickness,i,0])
                square([thickness, tabaSize]);
        }
        
        // Text inside for orientation
        translate([xSize/2,zSize/2,0])
            rotate([0,-180,0])
                text("Right", size=5, valign="center", halign="center", font=ft);

    }
}
