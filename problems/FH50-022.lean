import Mathlib

abbrev NNSquareMatrix := Σ n : ℕ, Matrix (Fin n) (Fin n) ℕ

def nnElementaryStrongShiftEquivalent (U V : NNSquareMatrix) : Prop :=
  ∃ R : Matrix (Fin U.1) (Fin V.1) ℕ,
    ∃ S : Matrix (Fin V.1) (Fin U.1) ℕ,
      U.2 = R * S ∧ V.2 = S * R

def nnStrongShiftEquivalent (U V : NNSquareMatrix) : Prop :=
  Relation.ReflTransGen nnElementaryStrongShiftEquivalent U V

def nnEightMatrix : Matrix (Fin 8) (Fin 8) ℕ :=
  ![![1, 1, 0, 0, 0, 0, 0, 0],
    ![0, 0, 1, 0, 0, 1, 0, 0],
    ![0, 0, 0, 1, 0, 0, 1, 0],
    ![0, 1, 0, 0, 1, 0, 0, 0],
    ![0, 0, 0, 1, 0, 1, 0, 0],
    ![0, 0, 1, 0, 0, 0, 1, 0],
    ![0, 0, 0, 0, 1, 0, 0, 1],
    ![1, 0, 0, 0, 0, 0, 0, 1]]

def nnOneMatrix : Matrix (Fin 1) (Fin 1) ℕ :=
  fun _ _ => 2

def arxivleanConjecture : Prop :=
  nnStrongShiftEquivalent (⟨8, nnEightMatrix⟩ : NNSquareMatrix) (⟨1, nnOneMatrix⟩ : NNSquareMatrix)
