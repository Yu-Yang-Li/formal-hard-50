import Mathlib

def DirectedNonemptySubset (L : Type) [PartialOrder L] (D : Set L) : Prop :=
  D.Nonempty ∧
    ∀ a ∈ D, ∀ b ∈ D, ∃ c ∈ D, a ≤ c ∧ b ≤ c

def MeetContinuousProperty (L : Type) [CompleteLattice L] : Prop :=
  ∀ x : L, ∀ D : Set L, DirectedNonemptySubset L D →
    x ⊓ sSup D = sSup ((fun d : L => x ⊓ d) '' D)

def ScottOpenSubset (L : Type) [CompleteLattice L] (U : Set L) : Prop :=
  (∀ x ∈ U, ∀ y : L, x ≤ y → y ∈ U) ∧
    (∀ D : Set L, DirectedNonemptySubset L D →
      sSup D ∈ U → ∃ d ∈ D, d ∈ U)

def ScottClosedSubset (L : Type) [CompleteLattice L] (A : Set L) : Prop :=
  ScottOpenSubset L Aᶜ

def ScottIrreducibleSubset (L : Type) [CompleteLattice L] (A : Set L) : Prop :=
  A.Nonempty ∧
    ∀ U V : Set L,
      ScottOpenSubset L U → ScottOpenSubset L V →
      (A ∩ U).Nonempty → (A ∩ V).Nonempty →
      (A ∩ (U ∩ V)).Nonempty

def arxivleanConjecture : Prop :=
  ∀ (L : Type) [CompleteLattice L] [Countable L],
  MeetContinuousProperty L →
    ∀ A : Set L,
      ScottClosedSubset L A → ScottIrreducibleSubset L A →
        ∃! q : L, A = {x : L | x ≤ q}
