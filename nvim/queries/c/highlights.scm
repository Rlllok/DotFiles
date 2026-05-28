;; extends

;; ============================================================================
;; 1. POINTER FORMATS (e.g., func UI_Widget* UI_WidgetFromKey(UI_Key key);)
;; ============================================================================

;; Handle pointer declarations/definitions: mark 'func' as keyword and the error block as type
(declaration
  type: (type_identifier) @keyword.storage
  (ERROR (identifier) @type)
  declarator: (pointer_declarator)
  (#eq? @keyword.storage "func"))

(function_definition
  type: (type_identifier) @keyword.storage
  (ERROR (identifier) @type)
  declarator: (pointer_declarator)
  (#eq? @keyword.storage "func"))


;; ============================================================================
;; 2. STANDARD FORMATS (e.g., func void UI_Demo())
;; ============================================================================

;; Handle standard definitions/declarations without pointers
(declaration
  type: (type_identifier) @keyword.storage
  (ERROR (identifier) @type)
  (#eq? @keyword.storage "func"))

(function_definition
  type: (type_identifier) @keyword.storage
  (ERROR (identifier) @type)
  (#eq? @keyword.storage "func"))


;; ============================================================================
;; 3. CORE FALLBACKS (Applies colors to names and lone keywords)
;; ============================================================================

;; Always match the actual function name inside any function declarator block
(function_declarator
  declarator: (identifier) @function)

;; Catch-all: Ensure the word "func" is always highlighted as a keyword globally
((identifier) @keyword.storage (#eq? @keyword.storage "func"))
((type_identifier) @keyword.storage (#eq? @keyword.storage "func"))
