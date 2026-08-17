// GEELY EX2 — BUMPER TPU COM BOSL2
// V0.1 — versão parametrizada com slot lateral para lâmina canivete
// Dependência: BOSL2, instalado na biblioteca do OpenSCAD.
// Eixos: X = comprimento, Y = largura, Z = espessura.
//
// IMPORTANTE: as dimensões abaixo são provisórias.
// Medir a chave física e salvar uma cópia _amostra01 antes de imprimir.

include <BOSL2/std.scad>;

$fn = 72;

// ===================== CORPO DA CHAVE =====================
KEY_L = 78.0;       // comprimento no eixo X, mm
KEY_W = 39.0;       // largura no eixo Y, mm
KEY_T = 16.0;       // espessura no eixo Z, mm
KEY_R = 8.0;        // raio aproximado dos cantos em planta, mm

// ===================== FOLGAS E ESTRUTURA =====================
CLR_X = 0.40;
CLR_Y = 0.25;
CLR_Z = 0.35;
BACK_THICK = 1.20;
SIDE_WALL = 1.60;
FACE_CLEARANCE = 1.00;
LIP_IN = 0.80;
LIP_H = 0.90;

// ===================== ARGOLA / ORELHA =====================
// false = usa a abertura RING_NOTCH_*;
// true  = cria uma orelha integrada para chaveiro.
KEYRING_EAR_ENABLE = false;
RING_NOTCH_L = 11.0;
RING_NOTCH_W = 12.0;
KEYRING_EAR_LENGTH = 14.0;
KEYRING_EAR_WIDTH = 10.0;
KEYRING_EAR_THICKNESS = 3.00;
KEYRING_HOLE_DIAMETER = 4.50;
KEYRING_EAR_R = 2.50;

// ===================== SLOT DA LÂMINA =====================
BLADE_SLOT_ENABLE = true;
BLADE_SLOT_SIDE = 1;       // +1 = parede Y positiva; -1 = parede Y negativa
BLADE_SLOT_X = 20.0;       // centro longitudinal do slot
BLADE_SLOT_W = 20.0;       // comprimento da janela no eixo X
BLADE_SLOT_Z = 7.0;        // centro vertical, a partir da base
BLADE_SLOT_H = 7.0;        // altura da janela no eixo Z
BLADE_SLOT_R = 1.50;       // raio dos cantos

// ===================== DIMENSÕES DERIVADAS =====================
INNER_L = KEY_L + CLR_X;
INNER_W = KEY_W + 2*CLR_Y;
INNER_T = KEY_T + CLR_Z;
OUTER_L = INNER_L + 2*SIDE_WALL;
OUTER_W = INNER_W + 2*SIDE_WALL;
WALL_H = max(1.0, INNER_T - FACE_CLEARANCE);
WALL_BASE_H = max(0.50, WALL_H - LIP_H + 0.05);
OUTER_H = BACK_THICK + WALL_H;
OUTER_R = min(KEY_R + SIDE_WALL, OUTER_W/2 - 0.30);
INNER_R = min(KEY_R, INNER_W/2 - 0.30);
BASE_R = max(0.10, min(OUTER_R, BACK_THICK/2 - 0.05));
WALL_R = max(0.10, min(OUTER_R, OUTER_H/2 - 0.05));
INNER_WALL_R = max(0.10, min(INNER_R, WALL_H/2 - 0.05));
LIP_R = 0.0; // topo plano evita triângulos colineares no STL
SLOT_R_SAFE = max(0.10, min(BLADE_SLOT_R, min(BLADE_SLOT_W, BLADE_SLOT_H)/2 - 0.10));

// ===================== PRIMITIVAS BOSL2 =====================
// Converte um cuboid BOSL2 centrado em um sólido com origem em x=0, z=0.
module b2_prism(l, w, h, r) {
    translate([l/2, 0, h/2])
        cuboid([l, w, h], rounding=r, edges="Z", anchor=CENTER);
}

module b2_slot_xz(w, h, r, depth) {
    cuboid([w, depth, h], rounding=r, edges="Y", anchor=CENTER);
}

// ===================== COMPONENTES =====================
module base_plate() {
    b2_prism(OUTER_L, OUTER_W, BACK_THICK, BASE_R);
}

module side_ring() {
    difference() {
        b2_prism(OUTER_L, OUTER_W, BACK_THICK + WALL_BASE_H, WALL_R);
        translate([SIDE_WALL, 0, BACK_THICK-0.05])
            b2_prism(INNER_L, INNER_W, WALL_BASE_H+0.20, INNER_WALL_R);
    }
}

module retention_lip() {
    difference() {
        translate([0, 0, BACK_THICK+WALL_H-LIP_H])
            b2_prism(OUTER_L, OUTER_W, LIP_H, LIP_R);
        translate([SIDE_WALL+LIP_IN, 0, BACK_THICK+WALL_H-LIP_H-0.05])
            b2_prism(INNER_L-2*LIP_IN, INNER_W-2*LIP_IN,
                     LIP_H+0.20, max(0.10, min(INNER_R-LIP_IN, LIP_H/2-0.05)));
    }
}

module ring_notch_cut() {
    translate([RING_NOTCH_L/2, 0, OUTER_H/2])
        cuboid([RING_NOTCH_L, RING_NOTCH_W, OUTER_H+0.40], anchor=CENTER);
}

module keyring_ear() {
    if (KEYRING_EAR_ENABLE) {
        difference() {
            translate([-KEYRING_EAR_LENGTH/2, 0, KEYRING_EAR_THICKNESS/2])
                cuboid([KEYRING_EAR_LENGTH, KEYRING_EAR_WIDTH, KEYRING_EAR_THICKNESS],
                       rounding=KEYRING_EAR_R, edges="Z", anchor=CENTER);
            translate([-KEYRING_EAR_LENGTH*0.62, 0, KEYRING_EAR_THICKNESS/2])
                cylinder(h=KEYRING_EAR_THICKNESS+0.40,
                         d=KEYRING_HOLE_DIAMETER, center=true);
        }
    }
}

module blade_slot_cut() {
    if (BLADE_SLOT_ENABLE) {
        slot_y = BLADE_SLOT_SIDE > 0
            ? OUTER_W/2 - SIDE_WALL/2
            : -OUTER_W/2 + SIDE_WALL/2;
        translate([BLADE_SLOT_X, slot_y, BLADE_SLOT_Z])
            b2_slot_xz(BLADE_SLOT_W, BLADE_SLOT_H, SLOT_R_SAFE,
                       SIDE_WALL+0.40);
    }
}

module bumper() {
    difference() {
        union() {
            // side_ring() já contém a base e as paredes; não duplicar base_plate().
            side_ring();
            retention_lip();
            keyring_ear();
        }
        if (!KEYRING_EAR_ENABLE)
            ring_notch_cut();
        blade_slot_cut();
    }
}

bumper();

// ===================== AJUSTE RÁPIDO =====================
// 1. Atualize KEY_L, KEY_W, KEY_T e KEY_R com a chave física.
// 2. Ajuste CLR_X, CLR_Y e CLR_Z para o encaixe.
// 3. Ajuste BLADE_SLOT_SIDE, X, W, Z e H na região da lâmina.
// 4. Use KEYRING_EAR_ENABLE=true se a chave não possuir furo para argola.
// 5. Quando a orelha estiver ativa, ajuste KEYRING_EAR_* e KEYRING_HOLE_DIAMETER.
// 6. Pressione F5 para preview e F6 para render completo.
// 7. Exporte STL somente após validar o encaixe.
