module Math.FourGeometries

import public Core.BoxInt
import public Core.VexelMaxel
import public Core.UnixelFraction
import public Core.ScaleTransform
import public Math.LinAlgebra.MetricTensor
import public Math.LinAlgebra.TernaryClassifier
import Geometry.LatticeTopology
import Data.Fin

%default total

------------------------------------------------------------------------
-- 1. THE 4 FUNDAMENTAL GEOMETRIES OF FINITE COSMOLOGY
------------------------------------------------------------------------

||| The 3-color chromogeometric sectors.
public export
data ColorCharge = RedColor | GreenColor | BlueColor

public export
Eq ColorCharge where
  RedColor == RedColor = True
  GreenColor == GreenColor = True
  BlueColor == BlueColor = True
  _ == _ = False

public export
Show ColorCharge where
  show RedColor   = "Red"
  show GreenColor = "Green"
  show BlueColor  = "Blue"

public export
ScaleTransform ColorCharge Nat where
  scaleTransform RedColor   = 1
  scaleTransform GreenColor = 2
  scaleTransform BlueColor  = 3

public export
InvertibleScaleTransform ColorCharge Nat where
  invertScaleTransform Z = RedColor
  invertScaleTransform (S Z) = RedColor
  invertScaleTransform (S (S Z)) = GreenColor
  invertScaleTransform (S (S (S _))) = BlueColor

||| Classifies each cell index in Fin 27 into its exact QCD Color Sector.
||| Uses the Z-axis coordinate layer (z = -1 -> Red, z = 0 -> Green, z = +1 -> Blue).
public export
cellColorSector : Fin 27 -> ColorCharge
cellColorSector idx =
  let c = fin27ToCoord idx
  in case coordZ c of
       Bit3MinusOne => RedColor
       Bit3Zero     => GreenColor
       Bit3PlusOne  => BlueColor

||| The 4 canonical metric geometries governing space, time, gauge, and causality:
||| 1. EllipticGeom  (Blue Sector  / det g = +1 / Spacelike Confinement Canvas)
||| 2. HyperbolicGeom (Red Sector   / det g = -1 / Timelike Non-Abelian Gauge Engine)
||| 3. ParabolicGeom  (Green Sector / det g = 0  / Lightlike Remainder Dissipation Sink)
||| 4. SubstrateGeom  (Causal Poset / g22 = 0, g12 = 1 / Irreversible Cosmological Arrow)
public export
data FundamentalGeometry = 
    EllipticGeom 
  | HyperbolicGeom 
  | ParabolicGeom 
  | SubstrateGeom

public export
Eq FundamentalGeometry where
  EllipticGeom   == EllipticGeom   = True
  HyperbolicGeom == HyperbolicGeom = True
  ParabolicGeom  == ParabolicGeom  = True
  SubstrateGeom  == SubstrateGeom  = True
  _              == _              = False

public export
Show FundamentalGeometry where
  show EllipticGeom   = "Elliptic (Blue, det=+1)"
  show HyperbolicGeom = "Hyperbolic (Red, det=-1)"
  show ParabolicGeom  = "Parabolic (Green, det=0)"
  show SubstrateGeom  = "Substrate (Causal, g22=0)"

------------------------------------------------------------------------
-- 2. CANONICAL MAXEL METRIC TENSORS
------------------------------------------------------------------------

||| Maps each fundamental geometry to its canonical Maxel metric tensor.
%inline
public export
geometryMetric : FundamentalGeometry -> Maxel
geometryMetric EllipticGeom   = gBlue
geometryMetric HyperbolicGeom = gRed
geometryMetric ParabolicGeom  = gBoole
geometryMetric SubstrateGeom  = gSubstrate

||| Computes the exact metric determinant for a fundamental geometry.
%inline
public export
geometryDeterminant : FundamentalGeometry -> Core.BoxInt.BoxInt
geometryDeterminant geom = detMetric (geometryMetric geom)

||| Computes the exact metric trace for a fundamental geometry.
%inline
public export
geometryTrace : FundamentalGeometry -> Core.BoxInt.BoxInt
geometryTrace geom = traceMetric (geometryMetric geom)

||| Evaluates the algebraic Quadrance Q_g(v) of a 2D Vexel under a fundamental geometry:
||| Q_g(v) = v1^2 * g11 + 2 * v1 * v2 * g12 + v2^2 * g22.
%inline
public export
evaluateQuadrance : FundamentalGeometry -> (v1 : Core.BoxInt.BoxInt) -> (v2 : Core.BoxInt.BoxInt) -> Core.BoxInt.BoxInt
evaluateQuadrance geom v1 v2 =
  let g = geometryMetric geom
      g11Val = g11 g
      g12Val = g12 g
      g22Val = g22 g
      term1 = (v1 * v1) * g11Val
      term2 = (intToBoxInt 2 * (v1 * v2)) * g12Val
      term3 = (v2 * v2) * g22Val
  in term1 + term2 + term3

------------------------------------------------------------------------
-- 3. THE 4 GEOMETRIC ACTION THEOREMS
--    Each geometry governs a distinct, non-negotiable physical law
------------------------------------------------------------------------

||| 1. Elliptic Action: Confinement & Positive Quadrance.
||| For any non-zero spatial displacement (1, 0), Q_Elliptic = +1 (strictly positive).
%inline
public export
ellipticConfinementAction : (v1 : Core.BoxInt.BoxInt) -> (v2 : Core.BoxInt.BoxInt) -> Core.BoxInt.BoxInt
ellipticConfinementAction v1 v2 = evaluateQuadrance EllipticGeom v1 v2

||| 2. Hyperbolic Action: Non-Abelian Quantum Phase & Lightcones.
||| Admits lightlike null vectors with zero quadrance (e.g. (1, 1) -> 1 - 1 = 0).
%inline
public export
hyperbolicPhaseAction : (v1 : Core.BoxInt.BoxInt) -> (v2 : Core.BoxInt.BoxInt) -> Core.BoxInt.BoxInt
hyperbolicPhaseAction v1 v2 = evaluateQuadrance HyperbolicGeom v1 v2

||| 3. Parabolic Action: Degenerate Dissipation Channel.
||| Disregards orthogonal direction components (g22 = 0, g12 = 0) allowing remainder drainage.
%inline
public export
parabolicDissipationAction : (v1 : Core.BoxInt.BoxInt) -> (v2 : Core.BoxInt.BoxInt) -> Core.BoxInt.BoxInt
parabolicDissipationAction v1 v2 = evaluateQuadrance ParabolicGeom v1 v2

||| 4. Substrate Action: Irreversible Causal Arrow.
||| Satisfies g22 = 0 (no temporal feedback) and g12 = 1 (unidirectional matter bias).
%inline
public export
substrateCausalArrowAction : Maxel -> Bool
substrateCausalArrowAction g =
  unwrapBox (g22 g) == 0 && unwrapBox (g12 g) == 1

public export
substrateCausalArrowActionBit : Maxel -> Bit
substrateCausalArrowActionBit g =
  if unwrapBox (g22 g) == 0 && unwrapBox (g12 g) == 1 then One else Zero

------------------------------------------------------------------------
-- 4. COSMIC BUDGET DECOMPOSITION ACROSS THE 4 GEOMETRIES
------------------------------------------------------------------------

||| Decomposes the 4th Primorial budget (210) across the Chromogeometric Triad and Substrate:
||| - Elliptic Blue Sector     = 27  (3^3 Spacetime Lattice Basis)
||| - Hyperbolic Red Sector    = 128 (2^7 Symplectic Law ROM)
||| - Parabolic Green Sector   = 55  (Accumulated Dark Matter Residue)
||| Total Budget = 27 + 128 + 55 = 210 = 2 * 3 * 5 * 7.
%inline
public export
cosmicBudgetByGeometry : FundamentalGeometry -> Nat
cosmicBudgetByGeometry EllipticGeom   = 27
cosmicBudgetByGeometry HyperbolicGeom = 128
cosmicBudgetByGeometry ParabolicGeom  = 55
cosmicBudgetByGeometry SubstrateGeom  = 210

||| Evaluates the exact rational chance proportion of each geometry.
%inline
public export
cosmicChanceByGeometry : FundamentalGeometry -> UnixelFraction
cosmicChanceByGeometry geom =
  let tally = cosmicBudgetByGeometry geom
  in if geom == SubstrateGeom
       then unitUnixelFraction
       else hehnerTallyToChance tally 210

------------------------------------------------------------------------
-- 5. CONSTRUCTIVE FORMAL AUDIT PROOFS
------------------------------------------------------------------------

||| Audits the Determinant Classification of the 4 Geometries:
||| det(Elliptic)   = +1
||| det(Hyperbolic) = -1
||| det(Parabolic)  = 0
||| det(Substrate)  = -1 (with asymmetric g22 = 0)
%inline
public export
auditFourGeometriesDeterminantsProof : Bool
auditFourGeometriesDeterminantsProof =
  let detEll = geometryDeterminant EllipticGeom
      detHyp = geometryDeterminant HyperbolicGeom
      detPar = geometryDeterminant ParabolicGeom
      detSub = geometryDeterminant SubstrateGeom
  in unwrapBox detEll == 1 &&
     unwrapBox detHyp == (-1) &&
     unwrapBox detPar == 0 &&
     unwrapBox detSub == (-1)

||| Audits the Cosmic Synthesis of the 4 Geometries:
||| 1. Quadrance of (1, 1) under Hyperbolic is exactly 0 (Lightcone).
||| 2. Quadrance of (1, 0) under Elliptic is exactly 1 (Confinement).
||| 3. Budget partition 27 + 128 + 55 == 210 (Primorial 210).
public export
auditFourGeometriesCosmicSynthesisProof : Bool
auditFourGeometriesCosmicSynthesisProof =
  let one = intToBoxInt 1
      zero = intToBoxInt 0
      qHyp = hyperbolicPhaseAction one one
      qEll = ellipticConfinementAction one zero
      bTotal = cosmicBudgetByGeometry EllipticGeom +
               cosmicBudgetByGeometry HyperbolicGeom +
               cosmicBudgetByGeometry ParabolicGeom
      okHyp = case unwrapBox qHyp of
                0 => True
                _ => False
      okEll = case unwrapBox qEll of
                1 => True
                _ => False
      okTot = natEq bTotal 210
  in okHyp && okEll && okTot

------------------------------------------------------------------------
-- 6. WILDBERGER PLANAR CHROMOGEOMETRY THEOREMS (THEOREMS 6 & 8)
------------------------------------------------------------------------

||| Wildberger Theorem 6: Three-Fold Quadrance Metric Symmetry (Q_b^2 == Q_r^2 + Q_g^2).
||| For displacement (dx, dy): Q_b = dx^2 + dy^2, Q_r = dx^2 - dy^2, Q_g = 2*dx*dy.
public export
evaluateThreeFoldQuadranceSymmetry : (dx : BoxInt) -> (dy : BoxInt) -> Bool
evaluateThreeFoldQuadranceSymmetry dx dy =
  let qb = (dx * dx) + (dy * dy)
      qr = (dx * dx) - (dy * dy)
      qg = intToBoxInt 2 * (dx * dy)
  in (qb * qb) == (qr * qr) + (qg * qg)

||| Computes the (Blue, Red, Green) Quadreas of a triangle A1(x1, y1), A2(x2, y2), A3(x3, y3).
public export
evaluateThreeFoldQuadrea : (x1 : BoxInt) -> (y1 : BoxInt) ->
                           (x2 : BoxInt) -> (y2 : BoxInt) ->
                           (x3 : BoxInt) -> (y3 : BoxInt) -> (BoxInt, BoxInt, BoxInt)
evaluateThreeFoldQuadrea x1 y1 x2 y2 x3 y3 =
  let dx12 = x2 - x1
      dy12 = y2 - y1
      dx23 = x3 - x2
      dy23 = y3 - y2
      dx31 = x1 - x3
      dy31 = y1 - y3
      -- Blue Quadrances
      qb1 = (dx12 * dx12) + (dy12 * dy12)
      qb2 = (dx23 * dx23) + (dy23 * dy23)
      qb3 = (dx31 * dx31) + (dy31 * dy31)
      ab  = (qb1 + qb2 + qb3) * (qb1 + qb2 + qb3) - intToBoxInt 2 * ((qb1 * qb1) + (qb2 * qb2) + (qb3 * qb3))
      -- Red Quadrances
      qr1 = (dx12 * dx12) - (dy12 * dy12)
      qr2 = (dx23 * dx23) - (dy23 * dy23)
      qr3 = (dx31 * dx31) - (dy31 * dy31)
      ar  = (qr1 + qr2 + qr3) * (qr1 + qr2 + qr3) - intToBoxInt 2 * ((qr1 * qr1) + (qr2 * qr2) + (qr3 * qr3))
      -- Green Quadrances
      qg1 = intToBoxInt 2 * (dx12 * dy12)
      qg2 = intToBoxInt 2 * (dx23 * dy23)
      qg3 = intToBoxInt 2 * (dx31 * dy31)
      ag  = (qg1 + qg2 + qg3) * (qg1 + qg2 + qg3) - intToBoxInt 2 * ((qg1 * qg1) + (qg2 * qg2) + (qg3 * qg3))
  in (ab, ar, ag)

||| Wildberger Theorem 8: The Three-Fold Quadrea Theorem (A_b == -A_r == -A_g).
public export
verifyThreeFoldQuadreaTheorem : (x1 : BoxInt) -> (y1 : BoxInt) ->
                                (x2 : BoxInt) -> (y2 : BoxInt) ->
                                (x3 : BoxInt) -> (y3 : BoxInt) -> Bool
verifyThreeFoldQuadreaTheorem x1 y1 x2 y2 x3 y3 =
  let (ab, ar, ag) = evaluateThreeFoldQuadrea x1 y1 x2 y2 x3 y3
  in ab == (intToBoxInt (-1) * ar) && ab == (intToBoxInt (-1) * ag)

||| Audits Wildberger Chromogeometry Theorems 6 & 8 on concrete triangle coordinates.
public export
auditThreeFoldChromogeometryProof : Bool
auditThreeFoldChromogeometryProof =
  let t6Ok = evaluateThreeFoldQuadranceSymmetry (intToBoxInt 3) (intToBoxInt 4)
      t8Ok = verifyThreeFoldQuadreaTheorem (intToBoxInt 0) (intToBoxInt 0)
                                           (intToBoxInt 4) (intToBoxInt 0)
                                           (intToBoxInt 0) (intToBoxInt 3)
  in t6Ok && t8Ok

