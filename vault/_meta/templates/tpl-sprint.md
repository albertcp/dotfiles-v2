---
tipo: sprint
proyecto: "<% tp.system.prompt("Proyecto") %>"
pi: "<% tp.system.prompt("PI") %>"
sprint: "<% tp.system.prompt("Número de sprint (ej: 1.2)") %>"
status: activo
fecha_inicio: "<% tp.system.prompt("Fecha inicio (YYYY-MM-DD)") %>"
fecha_fin: "<% tp.system.prompt("Fecha fin (YYYY-MM-DD)") %>"
tags: [sprint]
---

# Sprint <% tp.frontmatter.sprint %> — <% tp.frontmatter.proyecto %> / PI <% tp.frontmatter.pi %>

| Campo | Valor |
|-------|-------|
| **Proyecto** | [[<% tp.frontmatter.proyecto %>]] |
| **PI** | [[PI <% tp.frontmatter.pi %>\|PI <% tp.frontmatter.pi %>]] |
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
WHERE contains(proyectos, "<% tp.frontmatter.proyecto %>")
	AND date(file.name) >= date("<% tp.frontmatter.fecha_inicio %>")
	AND date(file.name) <= date("<% tp.frontmatter.fecha_fin %>")
SORT file.name ASC
```

## Notas

