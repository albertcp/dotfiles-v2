---
tipo: sprint
proyecto: "{{VALUE:proyecto}}"
pi: "{{VALUE:pi}}"
sprint: "{{VALUE:sprint}}"
status: activo
fecha_inicio: "<% tp.system.prompt('Fecha inicio (YYYY-MM-DD)') %>"
fecha_fin: "<% tp.system.prompt('Fecha fin (YYYY-MM-DD)') %>"
tags: [sprint]
---

# Sprint {{VALUE:sprint}} — {{VALUE:proyecto}} / PI {{VALUE:pi}}

| Campo | Valor |
|-------|-------|
| **Proyecto** | [[{{VALUE:proyecto}}]] |
| **PI** | [[{{VALUE:proyecto}}/PI {{VALUE:pi}}/PI {{VALUE:pi}}\|PI {{VALUE:pi}}]] |
| **Período** | <% tp.frontmatter.fecha_inicio %> → <% tp.frontmatter.fecha_fin %> |
| **Estado** | <% tp.frontmatter.status %> |

## Objetivos del sprint

- [ ]

## Tareas

- [ ]

## Daily Notes

```dataview
TABLE without id
	file.link as "Día",
	summary as "Resumen"
FROM "diario"
WHERE contains(proyectos, "{{VALUE:proyecto}}")
	AND date(file.name) >= date("<% tp.frontmatter.fecha_inicio %>")
	AND date(file.name) <= date("<% tp.frontmatter.fecha_fin %>")
SORT file.name ASC
```

## Notas
