// GEELY EX2 — BUMPER TPU COM SLOT LATERAL PARA LÂMINA CANIVETE
// V0.2 PARAMÉTRICA
// Protege traseira e laterais; face dos botões aberta.
// O slot lateral é uma janela simples no plano X/Z: ajuste posição, largura e altura.
// Eixos: X = comprimento (argola -> topo), Y = largura, Z = espessura.
//
// IMPORTANTE: as dimensões da chave são preliminares e não oficiais.
// Medir a chave física antes de imprimir a peça completa.

$fn = 72;

// ===================== MEDIDAS DA CHAVE =====================
KEY_L = 78.0;       // comprimento do corpo da chave, eixo X, mm
KEY_W = 39.0;       // largura máxima, eixo Y, mm
KEY_T = 16.0;       // espessura máxima, eixo Z, mm
KEY_R = 8.0;        // raio aproximado dos cantos em planta, mm

// ===================== FOLGAS / PAREDES TPU =====================
CLR_X = 0.40;       // folga interna em X
CLR_Y = 0.25;       // folga interna por lado em Y
CLR_Z = 0.35;       // folga interna em Z
BACK = 1.20;        // base traseira
SIDE_WALL = 1.60;   // parede lateral
FACE_CLEARANCE = 1.00; // parede termina abaixo da face da chave
LIP_IN = 0.80;      // ressalto interno de retenção
LIP_H = 0.90;       // altura do ressalto

// ===================== ARGOLA =====================
RING_NOTCH_L = 11.0;
RING_NOTCH_W = 12.0;

// ===================== SLOT DA LÂMINA CANIVETE =====================
BLADE_SLOT_ENABLE = true;
BLADE_SLOT_SIDE = 1;       // +1 = parede Y positiva; -1 = parede Y negativa
BLADE_SLOT_X = 20.0;        // centro da janela ao longo de X
BLADE_SLOT_W = 20.0;        // largura/comprimento da janela em X
BLADE_SLOT_Z = 7.0;         // centro da janela em Z, medido a partir da base
BLADE_SLOT_H = 7.0;         // altura da janela em Z
BLADE_SLOT_R = 1.5;         // raio dos cantos da janela

// Para uma lâmina que deve ser aberta com a capa instalada, comece com
// BLADE_SLOT_W = 20–25 mm e BLADE_SLOT_H = 7–9 mm.
// Ajuste somente após confirmar a dobradiça e o botão de liberação.

// ===================== DIMENSÕES DERIVADAS =====================
INNER_L = KEY_L + CLR_X;
INNER_W = KEY_W + 2*CLR_Y;
INNER_T = KEY_T + CLR_Z;
OUTER_L = INNER_L + 2*SIDE_WALL;
OUTER_W = INNER_W + 2*SIDE_WALL;
WALL_H = max(1.0, INNER_T - FACE_CLEARANCE);
OUTER_H = BACK + WALL_H;
OUTER_R = min(KEY_R + SIDE_WALL, OUTER_W/2 - 0.30);
INNER_R = min(KEY_R, INNER_W/2 - 0.30);

// ===================== PRIMITIVAS =====================
module rounded2d(l, w, r) {
    hull() {
        for (x = [r, l-r])
            for (y = [-w/2+r, w/2-r])
                translate([x, y]) circle(r=r);
    }
}

module rounded_rect_centered_2d(w, h, r) {
    hull() {
        for (x = [-w/2+r, w/2-r])
            for (y = [-h/2+r, h/2-r])
                translate([x, y]) circle(r=r);
    }
}

module rounded_prism(l, w, h, r) {
    linear_extrude(height=h) rounded2d(l, w, r);
}

// Janela arredondada no plano X/Z, extrudida através da parede Y.
module rounded_slot_xz(w, h, r, depth) {
    rotate([90,0,0])
        linear_extrude(height=depth, center=true)
            rounded_rect_centered_2d(w, h, r);
}

module base_plate() {
    rounded_prism(OUTER_L, OUTER_W, BACK, OUTER_R);
}

module side_ring() {
    difference() {
        rounded_prism(OUTER_L, OUTER_W, OUTER_H, OUTER_R);
        translate([SIDE_WALL, 0, BACK-0.05])
            rounded_prism(INNER_L, INNER_W, WALL_H+0.20, INNER_R);
    }
}

module retention_lip() {
    difference() {
        translate([0, 0, BACK+WALL_H-LIP_H])
            rounded_prism(OUTER_L, OUTER_W, LIP_H, OUTER_R);
        translate([SIDE_WALL+LIP_IN, 0, BACK+WALL_H-LIP_H-0.05])
            rounded_prism(INNER_L-2*LIP_IN, INNER_W-2*LIP_IN,
                          LIP_H+0.20, max(0.5, INNER_R-LIP_IN));
    }
}

module ring_notch() {
    translate([-0.10, -RING_NOTCH_W/2, -0.10])
        cube([RING_NOTCH_L, RING_NOTCH_W, OUTER_H+0.30]);
}

module blade_slot() {
    if (BLADE_SLOT_ENABLE) {
        slot_y = BLADE_SLOT_SIDE > 0
            ? OUTER_W/2 - SIDE_WALL/2
            : -OUTER_W/2 + SIDE_WALL/2;
        translate([BLADE_SLOT_X, slot_y, BLADE_SLOT_Z])
            rounded_slot_xz(BLADE_SLOT_W, BLADE_SLOT_H, BLADE_SLOT_R,
                            SIDE_WALL+0.40);
    }
}

module bumper() {
    difference() {
        union() {
            base_plate();
            side_ring();
            retention_lip();
        }
        ring_notch();
        blade_slot();
    }
}

bumper();

// ===================== AJUSTE RÁPIDO =====================
// 1. Meça a posição central da dobradiça/botão em X e Z.
// 2. Ajuste BLADE_SLOT_X para deslocar a janela ao longo da chave.
// 3. Ajuste BLADE_SLOT_W para aumentar/reduzir a largura em X.
// 4. Ajuste BLADE_SLOT_H para aumentar/reduzir a altura em Z.
// 5. Use BLADE_SLOT_SIDE = -1 se a lâmina estiver na outra lateral.
// 6. Mantenha BLADE_SLOT_R >= 1.5 mm para reduzir rasgos no TPU.
// 7. Imprima primeiro um trecho de 10–15 mm ou uma amostra da região do slot.
