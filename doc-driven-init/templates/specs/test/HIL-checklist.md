# {{PROJECT_NAME}} — {{HIL_TITLE}} 驗收清單 / Acceptance Checklist

**原則 / Principle:** 模擬(fakes/stubs)只供 CI 邏輯涵蓋;**正式驗收以真實 {{HIL_TARGET}} 跑通為準**,
涵蓋 happy + 失敗/邊界 + {{HIL_CRITICAL_DIMENSION}}。{{HIL_SCOPE}} 相關情境必須在此清單通過才算「完成」。

**現階段範圍 / Current scope:** {{HIL_CURRENT_SCOPE}}

---

## 前置 / Preconditions
- [ ] {{HIL_PRECONDITION_1}}
- [ ] {{HIL_PRECONDITION_2}}

## 測試套組 / Test fixtures
| 代號 | 說明 | 產生方式 |
|------|------|----------|
| A | {{HIL_FIXTURE_A}} | {{HIL_FIXTURE_A_HOW}} |
| B | {{HIL_FIXTURE_B}} | {{HIL_FIXTURE_B_HOW}} |

---

## A. {{HIL_SECTION_A}}
| # | Use case | 步驟 / Step | 預期 / Expected | Pass |
|---|----------|-------------|-----------------|------|
| 1 | {{UC_PREFIX}}-01 | {{HIL_STEP_1}} | {{HIL_EXPECT_1}} | ☐ |
| 2 | {{UC_PREFIX}}-02 | {{HIL_STEP_2}} | {{HIL_EXPECT_2}} | ☐ |

<!-- Rows are keyed to the use-case IDs in ARCHITECTURE.md §7. Each row is a manual/semi-automated
     acceptance step; ☐ → ☑ on sign-off. Add sections (B, C, …) per functional area. -->
