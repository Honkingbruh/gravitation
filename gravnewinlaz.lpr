program gravnewinlaz;
uses
    Graph, Crt, Classes, SysUtils, Graphics, LCLType, DateUtils;
type
    BodyC = object
    public
          x, y, rad: real;
          lastX, lastY: real;
          fX, fY: real;
          mass: real;
          CPTS : Array[0..87] of Array[0..2] of Integer;
          procedure setPos(newX, newY: real);
          procedure addForce(newFX, newFY: real);
          procedure draw2(pixCol : Integer);
          procedure drawCirc;
          procedure saveCirclePix;
          procedure drawSavedCirclePix;
          procedure draw;
end;
type BodyList = Array of BodyC;
type BodyListList = Array of BodyList;
var
   GraphDriver : Integer;
   GraphMode : Integer;
   ErrorCode : Integer;
   Circle1, Circle2, Circle3, Circle4 : BodyC;
   Circle5, Circle6 : BodyC;
   i, j : Integer;
   maxCoordX : Integer;
   maxCoordY : Integer;
   maxScreenX : Integer;
   maxScreenY : Integer;
   Bodies1 : BodyList;
   Bodies2 : BodyList;
procedure BodyC.setPos(newX, newY: real);
begin
     x := newX;
     y := newY;
end;
procedure BodyC.addForce(newFX, newFY: real);
begin
     fX := fX + newFX;
     fY := fY + newFY;
end;
function getDistance(C1, C2: BodyC): real;
begin
     getDistance := Sqrt((C1.x - C2.x)*(C1.x - C2.x) + (C1.y - C2.y)*(C1.y - C2.y));
end;
function screenToCoordsX(screenX: real): real;
begin
     screenToCoordsX := (2 * maxCoordX * (screenX - maxScreenX/2) / maxScreenX/2);
end;
function screenToCoordsY(screenY: real): real;
begin
     screenToCoordsY := -2 * maxCoordY * (screenY - maxScreenY/2) / maxScreenY/2;
end;
function coordsToScreenX(coordX: real): real;
begin
     coordsToScreenX := (0.5 * coordX * maxScreenX / maxCoordX) + maxScreenX/2;
end;
function coordsToScreenY(coordY: real): real;
begin
     coordsToScreenY := (-0.5 * coordY * maxScreenY / maxCoordY) + maxScreenY/2;
end;
procedure BodyC.draw2(pixcol: Integer);
var
   draw2X, draw2Y : Integer;
begin
        for draw2X := -15 to 15 do
        begin
            draw2Y := round(sqrt(225 - draw2X*draw2X) + 0.5);
            putPixel(draw2X + round(coordsToScreenX(x)), draw2Y + round(coordsToScreenY(y)), pixcol);
            putPixel(draw2X + round(coordsToScreenX(x)), -draw2Y + round(coordsToscreenY(y)), pixcol);
        end;
end;
procedure BodyC.drawCirc;
var
    CBx, CBy, CBd, CBxr, CByr : Integer;
begin
    CBx := 15;
    CBy := 0;
    CBd := 1-CBx;
    CBxr := round(coordsToScreenX(x));
    CByr := round(coordsToScreenY(y));
    while (CBx >= CBy) do
    begin
        putPixel(CBx + CBxr, CBy + CByr, 15);
        putPixel(CBy + CBxr, CBx + CByr, 15);
        putPixel(-CBx + CBxr, CBy + CByr, 15);
        putPixel(-CBy + CBxr, CBx + CByr, 15);
        putPixel(-CBx + CBxr, -CBy + CByr, 15);
        putPixel(-CBy + CBxr, -CBx + CByr, 15);
        putPixel(CBx + CBxr, -CBy + CByr, 15);
        putPixel(CBy + CBxr, -CBx + CByr, 15);
        CBy := CBy + 1;
        if CBd < 0 then
        begin
           CBd := CBd + 2*CBy + 1;
        end
        else
        begin
            CBx := CBx - 1;
            CBd := CBd + 2*(CBy - CBx + 1);
        end;
    end;
end;
procedure BodyC.saveCirclePix;
var
    CBx, CBy, CBd, CBxr, CByr, SCPN : Integer;
begin
    CBx := 15;
    CBy := 0;
    CBd := 1-CBx;
    CBxr := round(coordsToScreenX(x));
    CByr := round(coordsToScreenY(y));
    SCPN := 0;
    while (CBx >= CBy) do
    begin
        CPTS[8*SCPN][0] := CBx + CBxr;
        CPTS[8*SCPN][1] :=  CBy + CByr;
        CPTS[8*SCPN][2] := getPixel(CPTS[8*SCPN][0], CPTS[8*SCPN][1]);
        CPTS[8*SCPN + 1][0] := CBy + CBxr;
        CPTS[8*SCPN + 1][1] := CBx + CByr;
        CPTS[8*SCPN + 1][2] := getPixel(CPTS[8*SCPN + 1][0], CPTS[8*SCPN + 1][1]);
        CPTS[8*SCPN + 2][0] := -CBx + CBxr;
        CPTS[8*SCPN + 2][1] := CBy + CByr;
        CPTS[8*SCPN + 2][2] := getPixel(CPTS[8*SCPN + 2][0], CPTS[8*SCPN + 2][1]);
        CPTS[8*SCPN + 3][0] := -CBy + CBxr;
        CPTS[8*SCPN + 3][1] := CBx + CByr;
        CPTS[8*SCPN + 3][2] := getPixel(CPTS[8*SCPN + 3][0], CPTS[8*SCPN + 3][1]);
        CPTS[8*SCPN + 4][0] := -CBx + CBxr;
        CPTS[8*SCPN + 4][1] := -CBy + CByr;
        CPTS[8*SCPN + 4][2] := getPixel(CPTS[8*SCPN + 4][0], CPTS[8*SCPN + 4][1]);
        CPTS[8*SCPN + 5][0] := -CBy + CBxr;
        CPTS[8*SCPN + 5][1] := -CBx + CByr;
        CPTS[8*SCPN + 5][2] := getPixel(CPTS[8*SCPN + 5][0], CPTS[8*SCPN + 5][1]);
        CPTS[8*SCPN + 6][0] := CBx + CBxr;
        CPTS[8*SCPN + 6][1] := -CBy + CByr;
        CPTS[8*SCPN + 6][2] := getPixel(CPTS[8*SCPN + 6][0], CPTS[8*SCPN + 6][1]);
        CPTS[8*SCPN + 7][0] := CBy + CBxr;
        CPTS[8*SCPN + 7][1] := -CBx + CByr;
        CPTS[8*SCPN + 8][2] := getPixel(CPTS[8*SCPN + 7][0], CPTS[8*SCPN + 7][1]);
        SCPN := SCPN + 1;
        CBy := CBy + 1;
        if CBd < 0 then
        begin
           CBd := CBd + 2*CBy + 1;
        end
        else
        begin
            CBx := CBx - 1;
            CBd := CBd + 2*(CBy - CBx + 1);
        end;
    end;
end;

procedure BodyC.draw;
begin
     setColor(15);
     FillEllipse(round(coordsToScreenX(x)),round(coordsToScreenY(y)), 15, 15);
end;
procedure BodyC.drawSavedCirclePix;
var
   index: Integer;
begin
     for index := 0 to 87 do
     begin
         putPixel(CPTS[index][0], CPTS[index][1], CPTS[index][2]);
     end;
end;
procedure traceObject(Cxpx, pixcol: integer; Cxp: BodyC);
begin
     setColor(pixCol);
          Line(round(coordsToScreenX(Cxp.lastX)), round(coordsToScreenY(Cxp.lastY)), round(coordsToScreenX(Cxp.x)), round(coordsToScreenY(Cxp.y)));
end;
function updateForceAndPos(BodiesTemp : Bodylist): Bodylist;
var
   b, n : Integer;
   tempVarAB : real;
begin
     for b := 0 to 2 do
     begin
          n := b + 1;
          while n < 3 do
          begin
               if not (b = n) then
                  tempvarAB := BodiesTemp[b].mass * BodiesTemp[n].mass/getDistance(BodiesTemp[b], BodiesTemp[n]);
                  BodiesTemp[b].addForce((BodiesTemp[n].x - BodiesTemp[b].x)*tempvarAB, (BodiesTemp[n].y - BodiesTemp[b].y)*tempvarAB);
                  BodiesTemp[n].addForce((BodiesTemp[b].x - BodiesTemp[n].x)*tempvarAB, (BodiesTemp[b].y - BodiesTemp[n].y)*tempvarAB);
               n := n + 1;
          end;
     end;
     updateForceAndPos := BodiesTemp;
end;

var
   grmode, grdriver :smallint;
   rand: real;
   n : Integer;
   FromTime : TDateTime;
   num : Integer;
begin
     grdriver := DETECT;
     initgraph(grdriver,grmode, ' ' );
     setViewPort(0, 0, 1000, 1100, false);
     maxCoordX := 50;
     maxCoordY := 50;
     maxScreenX := 1000;
     maxScreenY := 1100;
     Circle1.setPos(-20, -10);
     Circle2.setPos(4, 25);
     Circle1.mass := 1;
     Circle2.mass := 1;
     Circle3.mass := 1;
     Circle3.setPos(17, -7);
     //Circle4.setPos(50, 4);
     Circle4.setPos(-20.00001, -10);
     Circle5.setPos(4, 25);
     Circle6.setPos(17, -7);
     //Circle8.setPos(50, 4);
     Circle4.mass := 1;
     Circle5.mass := 1;
     Circle6.mass := 1;
     //Circle7.mass := 1;
     //Circle8.mass := 1;
     Line(round(coordsToScreenX(0)),round(coordsToScreenY(maxCoordY)),round(coordsToScreenX(0)),round(coordsToScreenY(-maxCoordY)));
     Line(round(coordsToScreenX(-maxCoordX)),round(coordsToScreenY(0)),round(coordsToScreenX(maxCoordX)),round(coordsToScreenY(0)));
     i := 0;
     setLength(Bodies1, 3);
     Bodies1[0] := Circle1;
     Bodies1[1] := Circle2;
     Bodies1[2] := Circle3;
     //Bodies1[3] := Circle4;
     setLength(Bodies2, 3);
     Bodies2[0] := Circle4;
     Bodies2[1] := Circle5;
     Bodies2[2] := Circle6;
     //Bodies2[3] := Circle8;
     repeat
           FromTime := Now;
           {for n := 0 to 2 do
           begin
               drawSavedCirclePix(Bodies1[n], n + 1, 1);
               drawSavedCirclePix(Bodies2[n], n + 1, 2);
           end;}
           {drawSavedCirclePix(Circle1, 1);
           drawSavedCirclePix(Circle2, 2);
           drawSavedCirclePix(Circle3, 3);}
           {C1p[i][0] := round(coordsToScreenX(Circle1.x));
           C1p[i][1] := round(coordsToScreenY(Circle1.y));
           C2p[i][0] := round(coordsToScreenX(Circle2.x));
           C2p[i][1] := round(coordsToScreenY(Circle2.y));
           C3p[i][0] := round(coordsToScreenX(Circle3.x));
           C3p[i][1] := round(coordsToScreenY(Circle3.y));}
           {tempvar12 := Circle1.mass * Circle2.mass/getDistance(Circle1, Circle2);
           tempvar13 := Circle1.mass * Circle3.mass/getDistance(Circle1, Circle3);
           tempvar23 := Circle2.mass * Circle3.mass/getDistance(Circle2, Circle3);
           Circle1.addForce((Circle2.x - Circle1.x)*tempvar12, (Circle2.y - Circle1.y)*tempvar12);
           Circle1.addForce((Circle3.x - Circle1.x)*tempvar13, (Circle3.y - Circle1.y)*tempvar13);
           Circle2.addForce((Circle1.x - Circle2.x)*tempvar12, (Circle1.y - Circle2.y)*tempvar12);
           Circle2.addForce((Circle3.x - Circle2.x)*tempvar23, (Circle3.y - Circle2.y)*tempvar23);
           Circle3.addForce((Circle1.x - Circle3.x)*tempvar13, (Circle1.y - Circle3.y)*tempvar13);
           Circle3.addForce((Circle2.x - Circle3.x)*tempvar23, (Circle2.y - Circle3.y)*tempvar23);}
           {tempvar12 := Bodies[0].mass * Bodies[1].mass/getDistance(Bodies[0], Bodies[1]);
           tempvar13 := Bodies[0].mass * Bodies[2].mass/getDistance(Bodies[0], Bodies[2]);
           tempvar23 := Bodies[1].mass * Bodies[2].mass/getDistance(Bodies[1], Bodies[2]);
           Bodies[0].addForce((Bodies[1].x - Bodies[0].x)*tempvar12, (Bodies[1].y - Bodies[0].y)*tempvar12);
           Bodies[0].addForce((Bodies[2].x - Bodies[0].x)*tempvar13, (Bodies[2].y - Bodies[0].y)*tempvar13);
           Bodies[1].addForce((Bodies[0].x - Bodies[1].x)*tempvar12, (Bodies[0].y - Bodies[1].y)*tempvar12);
           Bodies[1].addForce((Bodies[2].x - Bodies[1].x)*tempvar23, (Bodies[2].y - Bodies[1].y)*tempvar23);
           Bodies[2].addForce((Bodies[0].x - Bodies[2].x)*tempvar13, (Bodies[0].y - Bodies[2].y)*tempvar13);
           Bodies[2].addForce((Bodies[1].x - Bodies[2].x)*tempvar23, (Bodies[1].y - Bodies[2].y)*tempvar23);}
           for n := 0 to 2 do
           begin
               Bodies1[n].drawSavedCirclePix;
               Bodies2[n].drawSavedCirclePix;
           end;
           Bodies1 := updateForceAndPos(Bodies1);
           Bodies2 := updateForceAndPos(Bodies2);
           for n := 0 to 2 do
           begin
               Bodies1[n].lastX := Bodies1[n].x;
               Bodies1[n].lastY := Bodies1[n].y;
               Bodies1[n].setPos(Bodies1[n].x + (Bodies1[n].fX * 0.007)/Bodies1[n].mass, Bodies1[n].y + ((Bodies1[n].fY * 0.007)/Bodies1[n].mass));
               Bodies2[n].lastX := Bodies2[n].x;
               Bodies2[n].lastY := Bodies2[n].y;
               Bodies2[n].setPos(Bodies2[n].x + (Bodies2[n].fX * 0.007)/Bodies2[n].mass, Bodies2[n].y + ((Bodies2[n].fY * 0.007)/Bodies2[n].mass));
           end;
           traceObject(1, 2, Bodies1[0]);
           traceObject(2, 4, Bodies1[1]);
           traceObject(3, 14, Bodies1[2]);
           //traceObject(4, clPurple, Bodies1[3]);
           traceObject(1, 2, Bodies2[0]);
           traceObject(2, 4, Bodies2[1]);
           traceObject(3, 14, Bodies2[2]);
           //traceObject(4, clPurple, Bodies2[3]);
           Bodies1[0].saveCirclePix;
           Bodies1[1].saveCirclePix;
           Bodies1[2].saveCirclePix;
           //Bodies1[3].saveCirclePix;
           Bodies2[0].saveCirclePix;
           Bodies2[1].saveCirclePix;
           Bodies2[2].saveCirclePix;
           //Bodies2[3].saveCirclePix;
           Bodies1[0].drawCirc;
           Bodies1[1].drawCirc;
           Bodies1[2].drawCirc;
           //Bodies1[3].drawCirc;
           Bodies2[0].drawCirc;
           Bodies2[1].drawCirc;
           Bodies2[2].drawCirc;
           //Bodies2[3].drawCirc;
           {Circle1.lastX := Circle1.x;
           Circle1.lastY := Circle1.y;
           Circle1.setPos(Circle1.x + (Circle1.fX * 0.017)/Circle1.mass, Circle1.y + ((Circle1.fY * 0.017)/Circle1.mass));
           Circle2.lastX := Circle2.x;
           Circle2.lastY := Circle2.y;
           Circle2.setPos(Circle2.x + (Circle2.fX * 0.017)/Circle2.mass, Circle2.y + ((Circle2.fY * 0.017)/Circle2.mass));
           Circle3.lastX := Circle3.x;
           Circle3.lastY := Circle3.y;
           Circle3.setPos(Circle3.x + (Circle3.fX * 0.017)/Circle3.mass, Circle3.y + ((Circle3.fY * 0.017)/Circle3.mass));}
           {traceObject(1, 2, Circle1);
           traceObject(2, 4, Circle2);
           traceObject(3, 14, Circle3);}
           {saveCirclePix(Circle1, 1);
           saveCirclePix(Circle2, 2);
           saveCirclePix(Circle3, 3);}
           {saveCirclePix(Bodies1[0], 1, 1);
           saveCirclePix(Bodies1[1], 2, 1);
           saveCirclePix(Bodies1[2], 3, 1);
           saveCirclePix(Bodies2[0], 1, 2);
           saveCirclePix(Bodies2[1], 2, 2);
           saveCirclePix(Bodies2[2], 3, 2);}
           {Circle1.draw;
           Circle2.draw;
           Circle3.draw;}
           //Delay(5);
           i := i + 1;
           if i mod 500 = 0 then
           begin
                ClearViewPort;
                Line(round(coordsToScreenX(0)),round(coordsToScreenY(maxCoordY)),round(coordsToScreenX(0)),round(coordsToScreenY(-maxCoordY)));
                Line(round(coordsToScreenX(-maxCoordX)),round(coordsToScreenY(0)),round(coordsToScreenX(maxCoordX)),round(coordsToScreenY(0)));
           end;
           if i mod 50 = 0 then
           begin
                try
                writeln(round(1000/(MilliSecondsBetween(Now, FromTime) + 1)));
              Except
                 On EDivByZero do writeln('infinity ?');
             end;
           end;
     until KeyPressed;
     CloseGraph;
end.
