// BYD YUAN PRO — bumper protetor em TPU
// V0.1 PARAMÉTRICA — face frontal aberta, traseira e laterais protegidas.
// A BYD não publicou desenho dimensional da chave nas fontes consultadas.
// X = comprimento; Y = largura; Z = espessura.

$fn = 72;
MODEL_NAME = "BYD YUAN PRO";

// Medidas provisórias — substituir por medição da chave física
KEY_L = 78.0;       // X, mm
KEY_W = 34.0;       // Y, mm
KEY_T = 14.5;       // Z, mm
KEY_R = 7.0;

// Folgas e paredes TPU
CLR_X = 0.40;
CLR_Y = 0.25;
CLR_Z = 0.35;
BACK = 1.20;
SIDE_WALL = 1.60;
FACE_CLEARANCE = 1.00;
LIP_IN = 0.80;
LIP_H = 0.90;

// Abertura para argola/cinta; conferir se a chave do veículo possui esta interface.
RING_NOTCH_L = 11.0;
RING_NOTCH_W = 12.0;

// Como a forma da chave do Yuan Pro pode variar por mercado/versão, a abertura é ajustável.
MECH_SLOT = true;
MECH_SLOT_X = 12.0;
MECH_SLOT_L = 18.0;
MECH_SLOT_Z = 3.0;
MECH_SLOT_H = 5.0;
MECH_SLOT_SIDE = 1;

INNER_L = KEY_L + CLR_X;
INNER_W = KEY_W + 2*CLR_Y;
INNER_T = KEY_T + CLR_Z;
OUTER_L = INNER_L + 2*SIDE_WALL;
OUTER_W = INNER_W + 2*SIDE_WALL;
WALL_H = max(1.0, INNER_T - FACE_CLEARANCE);
OUTER_H = BACK + WALL_H;
OUTER_R = min(KEY_R + SIDE_WALL, OUTER_W/2 - 0.30);
INNER_R = min(KEY_R, INNER_W/2 - 0.30);

module rounded2d(l,w,r) {
    hull() {
        for (x=[r,l-r])
            for (y=[-w/2+r,w/2-r])
                translate([x,y]) circle(r=r);
    }
}
module rounded_prism(l,w,h,r) { linear_extrude(height=h) rounded2d(l,w,r); }
module base_plate() { rounded_prism(OUTER_L,OUTER_W,BACK,OUTER_R); }
module side_ring() {
    difference() {
        rounded_prism(OUTER_L,OUTER_W,OUTER_H,OUTER_R);
        translate([SIDE_WALL,0,BACK-0.05]) rounded_prism(INNER_L,INNER_W,WALL_H+0.20,INNER_R);
    }
}
module retention_lip() {
    difference() {
        translate([0,0,BACK+WALL_H-LIP_H]) rounded_prism(OUTER_L,OUTER_W,LIP_H,OUTER_R);
        translate([SIDE_WALL+LIP_IN,0,BACK+WALL_H-LIP_H-0.05])
            rounded_prism(INNER_L-2*LIP_IN,INNER_W-2*LIP_IN,LIP_H+0.20,max(0.5,INNER_R-LIP_IN));
    }
}
module ring_notch() {
    translate([-0.10,-RING_NOTCH_W/2,-0.10]) cube([RING_NOTCH_L,RING_NOTCH_W,OUTER_H+0.30]);
}
module mechanical_slot() {
    if (MECH_SLOT) {
        y0 = MECH_SLOT_SIDE > 0 ? OUTER_W/2-SIDE_WALL-0.10 : -OUTER_W/2+0.10;
        translate([MECH_SLOT_X,y0,MECH_SLOT_Z]) cube([MECH_SLOT_L,SIDE_WALL+0.40,MECH_SLOT_H]);
    }
}
module bumper() {
    difference() {
        union() { base_plate(); side_ring(); retention_lip(); }
        ring_notch();
        mechanical_slot();
    }
}

bumper();

// Confirmar na chave real: quantidade de botões, indicador, chave mecânica e argola.
// A face dos comandos permanece aberta por projeto.
