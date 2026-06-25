---
tipo: pi
proyecto: "<% tp.system.prompt("Proyecto") %>"
pi: "<% tp.system.prompt("Número de PI (ej: 2026.1)") %>"
status: planificado
fecha_inicio: "<% tp.system.prompt("Fecha inicio (YYYY-MM-DD)") %>"
fecha_fin: "<% tp.system.prompt("Fecha fin (YYYY-MM-DD)") %>"
tags: [pi]
---

# PI <% tp.frontmatter.pi %> — <% tp.frontmatter.proyecto %>

| Campo | Valor |
|-------|-------|
| **Proyecto** | [[<% tp.frontmatter.proyecto %>]] |
| **Período** | <% tp.frontmatter.fecha_inicio %> → <% tp.frontmatter.fecha_fin %> |
| **Estado** | <% tp.frontmatter.status %> |

## Sprints

```dataview
TABLE without id
	file.link as "Sprint",
	status as "Estado",
	fecha_inicio as "Inicio",
	fecha_fin as "Fin"
FROM "proyectos/<% tp.frontmatter.proyecto %>/PI <% tp.frontmatter.pi %>"
WHERE tipo = "sprint"
SORT sprint ASC
```

## Objetivos del PI

- [ ]

## Notas

