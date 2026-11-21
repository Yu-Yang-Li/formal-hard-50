import Mathlib

open scoped BigOperators

abbrev QBits (n : ℕ) := Fin n → Fin 2

abbrev QMat (n : ℕ) := Matrix (QBits n) (QBits n) ℂ

noncomputable def qX : Matrix (Fin 2) (Fin 2) ℂ :=
  fun a b => if a = b then 0 else 1

noncomputable def qZ : Matrix (Fin 2) (Fin 2) ℂ :=
  fun a b => if a = b then (if b = 0 then 1 else -1) else 0

noncomputable def qPauli (n : ℕ) (ell : Fin 4) (u v : QBits n) : QMat n := by
  classical
  exact (Complex.I ^ ell.val) •
    (fun a b => ∏ j : Fin n,
      ((qX ^ (u j).val) * (qZ ^ (v j).val)) (a j) (b j))

noncomputable def qPauliSet (n : ℕ) : Set (QMat n) :=
  {P | ∃ (ell : Fin 4) (u v : QBits n), P = qPauli n ell u v}

noncomputable def qUnitary (n : ℕ) (U : QMat n) : Prop := by
  classical
  exact U * Matrix.conjTranspose U = 1 ∧
    Matrix.conjTranspose U * U = 1

noncomputable def qClifford (n : ℕ) (C : QMat n) : Prop := by
  classical
  exact qUnitary n C ∧
    Set.image (fun P => C * P * Matrix.conjTranspose C) (qPauliSet n) =
      qPauliSet n

noncomputable def qPhasePauli (n : ℕ) (U : QMat n) : Prop :=
  ∃ (t : ℂ) (P : QMat n), ‖t‖ = 1 ∧ P ∈ qPauliSet n ∧ U = t • P

noncomputable def qHierarchyAux (n : ℕ) : ℕ → QMat n → Prop
  | 0, U => qPhasePauli n U
  | k + 1, U => by
      classical
      exact qUnitary n U ∧
        ∀ P : QMat n, P ∈ qPauliSet n →
          qHierarchyAux n k (U * P * Matrix.conjTranspose U)

noncomputable def qHierarchy (n k : ℕ) (U : QMat n) : Prop :=
  if k = 0 then False else qHierarchyAux n (k - 1) U

noncomputable def qPermutationMatrix (n : ℕ)
    (sigma : Equiv.Perm (QBits n)) : QMat n := by
  classical
  exact fun a b => if a = sigma b then 1 else 0

noncomputable def qDiagonalMatrix (n : ℕ) (d : QBits n → ℂ) : QMat n := by
  classical
  exact fun a b => if a = b then d b else 0

noncomputable def qGeneralisedSemiClifford (n : ℕ) (U : QMat n) : Prop := by
  classical
  exact qUnitary n U ∧
    ∃ (C_L C_R : QMat n) (sigma : Equiv.Perm (QBits n))
      (d : QBits n → ℂ),
      qClifford n C_L ∧ qClifford n C_R ∧
      (∀ b : QBits n, ‖d b‖ = 1) ∧
      U = C_L * qPermutationMatrix n sigma * qDiagonalMatrix n d * C_R

def arxivleanConjecture : Prop :=
  ∀ (n : ℕ), 1 ≤ n → ∀ (k : ℕ), 1 ≤ k → ∀ (U : QMat n), qHierarchy n k U → qGeneralisedSemiClifford n U
