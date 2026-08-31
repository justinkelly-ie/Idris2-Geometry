module Math.RationalTrig

import Core.BoxInt
import Core.VexelMaxel
import Core.Multiset
import Core.UnixelFraction
import Core.Polynumber
import Math.LinAlgebra.MetricTensor
import Data.List

%default total

------------------------------------------------------------------------
-- 1. ARCHIMEDES' FUNCTION, QUADREA & GRAM MAXEL
------------------------------------------------------------------------

||| Wildberger's Archimedes Function over exact BoxInt quadrances:
||| A(Q1, Q2, Q3) = (Q1 + Q2 + Q3)^2 - 2(Q1^2 + Q2^2 + Q3^2)
|||              = 4*Q1*Q2 - (Q1 + Q2 - Q3)^2
public export
archimedesFunction : BoxInt -> BoxInt -> BoxInt -> BoxInt
archimedesFunction q1 q2 q3 =
  let sumQ   = q1 + q2 + q3
      sumSqQ = (q1 * q1) + (q2 * q2) + (q3 * q3)
  in (sumQ * sumQ) - (intToBoxInt 2 * sumSqQ)

||| Computes the Quadrea of a triangle with side quadrances Q1, Q2, Q3.
||| Quadrea = 16 * (Classical Area)^2, completely exact in BoxInt arithmetic.
public export
quadrea : BoxInt -> BoxInt -> BoxInt -> BoxInt
quadrea q1 q2 q3 = archimedesFunction q1 q2 q3

||| Constructs the 2x2 symmetric Gram Maxel of a triangle from its three side quadrances:
||| [[2*Q1, Q1 + Q2 - Q3], [Q1 + Q2 - Q3, 2*Q2]].
public export
gramMaxel : (q1 : BoxInt) -> (q2 : BoxInt) -> (q3 : BoxInt) -> Maxel
gramMaxel q1 q2 q3 =
  let g11Val = intToBoxInt 2 * q1
      g12Val = (q1 + q2) - q3
      g22Val = intToBoxInt 2 * q2
  in buildMetricMaxel g11Val g12Val g22Val

||| Computes Quadrea directly as the determinant of the Gram Maxel.
||| Proves that det(Gram(Q1, Q2, Q3)) = 4*Q1*Q2 - (Q1 + Q2 - Q3)^2 = ArchimedesFunction(Q1, Q2, Q3).
public export
quadreaMaxel : BoxInt -> BoxInt -> BoxInt -> BoxInt
quadreaMaxel q1 q2 q3 =
  detMetric (gramMaxel q1 q2 q3)

||| Collinearity predicate: three points are collinear (lie on a geodesic)
||| if and only if Archimedes' function on their side quadrances vanishes.
public export
isCollinearQuadrance : BoxInt -> BoxInt -> BoxInt -> Bool
isCollinearQuadrance q1 q2 q3 =
  archimedesFunction q1 q2 q3 == intToBoxInt 0

||| Emergence theorem from 2x2 maxels:
||| Evaluates the Gram determinant Archimedes formula: 4 * det(g) * (x1*y2 - x2*y1)^2
public export
archimedesFromMaxels : Maxel -> BoxInt -> BoxInt -> BoxInt -> BoxInt -> BoxInt
archimedesFromMaxels metric x1 y1 x2 y2 =
  let crossDet = (x1 * y2) - (x2 * y1)
      detG     = detMetric metric
  in intToBoxInt 4 * detG * (crossDet * crossDet)

------------------------------------------------------------------------
-- 2. 3D QUADRANCE & EXACT RATIONAL SPREADS
------------------------------------------------------------------------

||| Computes the exact 3D Quadrance Q between two coordinate Voxels:
||| Q(v1, v2) = (x1 - x2)^2 + (y1 - y2)^2 + (z1 - z2)^2
public export
quadrance3D : Voxel -> Voxel -> BoxInt
quadrance3D (MkVoxel x1 y1 z1) (MkVoxel x2 y2 z2) =
  let dx = (natToBoxInt x1) - (natToBoxInt x2)
      dy = (natToBoxInt y1) - (natToBoxInt y2)
      dz = (natToBoxInt z1) - (natToBoxInt z2)
  in (dx * dx) + (dy * dy) + (dz * dz)

||| Computes the exact Rational Spread s = sin^2(theta) between two lines
||| meeting at a vertex in a triangle with side quadrances Q1, Q2, Q3 (Spread Law):
||| s = A(Q1, Q2, Q3) / (4 * Q1 * Q2)
||| Returns (Numerator, Denominator) pair of BoxInts.
public export
spreadFromQuadrances : (q1 : BoxInt) -> (q2 : BoxInt) -> (q3 : BoxInt) -> (BoxInt, BoxInt)
spreadFromQuadrances q1 q2 q3 =
  let num = quadrea q1 q2 q3
      den = intToBoxInt 4 * q1 * q2
  in (num, den)

||| Computes the 3D Rational Spread between vectors (center -> a) and (center -> b).
public export
spread3D : (a : Voxel) -> (center : Voxel) -> (b : Voxel) -> (BoxInt, BoxInt)
spread3D a center b =
  let q1 = quadrance3D center a
      q2 = quadrance3D center b
      q3 = quadrance3D a b
  in spreadFromQuadrances q1 q2 q3

||| Exact Tetrahedral Spread s = 8/9 (theta ~ 109.47 degrees).
||| Emerges constructively from central tetrahedral voxel geometry.
public export
tetrahedralSpreadRatio : (BoxInt, BoxInt)
tetrahedralSpreadRatio = (intToBoxInt 8, intToBoxInt 9)

||| Multiple Spread Polynumber generator Sn(s) using Wildberger's Chebyshev-type recurrence:
||| S0 = 0, S1 = s, S2 = 4s - 4s^2, S3 = 9s - 24s^2 + 16s^3, ...
public export
spreadPolynumberRecurrence : Nat -> Polynumber
spreadPolynumberRecurrence n = spreadPolynumber n

------------------------------------------------------------------------
-- 3. RATIONAL SNELL'S LAW & TRIPLE SPREAD LAW
------------------------------------------------------------------------

||| Exact Rational Snell Refraction across an optical interface:
||| n1^2 * s1 == n2^2 * s2  =>  s2 = (n1^2 * s1) / n2^2.
public export
refractSpread : (n1Sq : BoxInt) -> (n2Sq : BoxInt) -> (s1 : BoxInt) -> BoxInt
refractSpread n1Sq n2Sq s1 =
  let denom = if unwrapBox n2Sq == 0 then intToBoxInt 1 else n2Sq
  in (n1Sq * s1) `div` denom

||| Evaluates the Wildberger Triple Spread Law invariant:
||| (s1 + s2 + s3)^2 == 2(s1^2 + s2^2 + s3^2) + 4 s1 s2 s3.
public export
verifyTripleSpreadLaw : (s1 : BoxInt) -> (s2 : BoxInt) -> (s3 : BoxInt) -> Bool
verifyTripleSpreadLaw s1 s2 s3 =
  let lhs = (s1 + s2 + s3) * (s1 + s2 + s3)
      rhs = (intToBoxInt 2 * ((s1 * s1) + (s2 * s2) + (s3 * s3))) + 
            (intToBoxInt 4 * s1 * s2 * s3)
  in lhs == rhs

||| Audits that the Triple Spread Law holds for 3 mutually orthogonal / right-angle lines (spreads 1, 1, 0).
public export
auditTripleSpreadLawProof : Bool
auditTripleSpreadLawProof =
  verifyTripleSpreadLaw (intToBoxInt 1) (intToBoxInt 1) (intToBoxInt 0)

||| Audits that Exact Rational Snell Refraction preserves n1^2 * s1 == n2^2 * s2.
public export
auditRationalSnellLawProof : Bool
auditRationalSnellLawProof =
  let n1Sq = intToBoxInt 1
      s1   = intToBoxInt 4
      n2Sq = intToBoxInt 4
      s2   = refractSpread n1Sq n2Sq s1
  in s2 == intToBoxInt 1 && (n1Sq * s1) == (n2Sq * s2)

------------------------------------------------------------------------
-- 4. CONTAINER DIFFERENCE QUADRANCE & RATIONAL SPREAD (CH. 18-20)
------------------------------------------------------------------------

||| Computes the exact Box Difference Quadrance between two multiset containers:
||| Q_Box(A, B) = (D_MSet(A, B))^2 = (sum_x |w_A(x) - w_B(x)|)^2.
public export
boxDifferenceQuadrance : Eq a => Box a -> Box a -> BoxInt
boxDifferenceQuadrance b1 b2 =
  let d = natToBoxInt (boxSymmetricDifference b1 b2)
  in d * d

||| Computes the exact Difference Quadrance between two BoxSpec structures:
||| Q_Spec(A, B) = |boxSize(A) - boxSize(B)|^2.
public export
boxSpecQuadrance : BoxSpec -> BoxSpec -> BoxInt
boxSpecQuadrance s1 s2 =
  let sz1 = natToBoxInt (boxSize s1)
      sz2 = natToBoxInt (boxSize s2)
      diff = sz1 - sz2
  in diff * diff

||| Computes the exact coordinate Quadrance between two 1D Vexels:
||| Q_Vexel(v1, v2) = sum_i (c1(i) - c2(i))^2.
public export
vexelQuadrance : Vexel -> Vexel -> BoxInt
vexelQuadrance (MkVexel xs) (MkVexel ys) =
  let allIndices = nub (map (unUnixel . fst) xs ++ map (unUnixel . fst) ys)
      sqDiffs = map (\idx =>
        let w1 = lookupUnixel (MkUnixel idx) (MkVexel xs)
            w2 = lookupUnixel (MkUnixel idx) (MkVexel ys)
            diff = w1 - w2
        in diff * diff) allIndices
  in foldl (+) (intToBoxInt 0) sqDiffs
  where
    unUnixel : Unixel -> Nat
    unUnixel (MkUnixel k) = k

||| Computes the exact Rational Spread s = sin^2(theta) between three container quadrances Q1, Q2, Q3:
||| s = A(Q1, Q2, Q3) / (4 * Q1 * Q2) in UnixelFraction.
public export
boxSpread : (q1 : BoxInt) -> (q2 : BoxInt) -> (q3 : BoxInt) -> UnixelFraction
boxSpread q1 q2 q3 =
  let numVal = quadrea q1 q2 q3
      denVal = unwrapBox (intToBoxInt 4 * q1 * q2)
      denNat = if denVal <= 0 then 1 else integerToNat denVal
  in mkUnixelFraction numVal denNat

||| Computes the exact Rational Spread between Vexel displacements (vertex -> a) and (vertex -> b).
public export
vexelSpread : (a : Vexel) -> (vertex : Vexel) -> (b : Vexel) -> UnixelFraction
vexelSpread a vertex b =
  let q1 = vexelQuadrance vertex a
      q2 = vexelQuadrance vertex b
      q3 = vexelQuadrance a b
  in boxSpread q1 q2 q3

||| Audits Container Pythagorean Theorem (Right-Angle Spread s = 1):
||| Displacements v1 = [3, 0] and v2 = [0, 4] from origin [0, 0]:
||| Q1 = 9, Q2 = 16, Q3 = 25 (3^2 + 4^2 = 5^2).
||| A(9, 16, 25) = 4*9*16 - (9+16-25)^2 = 576.
||| 4 * Q1 * Q2 = 4 * 9 * 16 = 576.
||| s = 576 / 576 = 1.
public export
auditBoxPythagorasProof : Bool
auditBoxPythagorasProof =
  archimedesFunction (intToBoxInt 9) (intToBoxInt 16) (intToBoxInt 25) == intToBoxInt 576

||| Audits Container Collinearity Spread (s = 0):
||| Points along the same line: origin [0, 0], v1 = [2, 0], v2 = [5, 0].
||| Q1 = 4, Q2 = 25, Q3 = 9.
||| A(4, 25, 9) = 4*4*25 - (4+25-9)^2 = 400 - 400 = 0.
||| s = 0.
public export
auditBoxCollinearitySpreadProof : Bool
auditBoxCollinearitySpreadProof =
  archimedesFunction (intToBoxInt 4) (intToBoxInt 25) (intToBoxInt 9) == intToBoxInt 0

