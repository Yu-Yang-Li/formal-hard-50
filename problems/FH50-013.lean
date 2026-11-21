import Mathlib

theorem exists_group_virtually_RAAG_not_normally_virtually_RAAG :
    ∃ (G : Type) (_ : Group G),
      (∃ H : Subgroup G,
        H.FiniteIndex ∧
          ∃ (V : Type) (Γ : SimpleGraph V),
            Nonempty
              (H ≃*
                (FreeGroup V ⧸
                  Subgroup.normalClosure
                    {g : FreeGroup V |
                      ∃ v w : V,
                        Γ.Adj v w ∧
                          g =
                            FreeGroup.of v * FreeGroup.of w *
                              (FreeGroup.of v)⁻¹ * (FreeGroup.of w)⁻¹}))) ∧
        (∀ K : Subgroup G,
          K.FiniteIndex →
            K.Normal →
              ¬ ∃ (V : Type) (Γ : SimpleGraph V),
                Nonempty
                  (K ≃*
                    (FreeGroup V ⧸
                      Subgroup.normalClosure
                        {g : FreeGroup V |
                          ∃ v w : V,
                            Γ.Adj v w ∧
                              g =
                                FreeGroup.of v * FreeGroup.of w *
                                  (FreeGroup.of v)⁻¹ * (FreeGroup.of w)⁻¹}))) := by
  sorry
