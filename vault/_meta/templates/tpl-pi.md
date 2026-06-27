---
tipo: pi
proyecto: "{{VALUE:proyecto}}"
pi: "{{VALUE:pi}}"
status: planificado
fecha_inicio: "<% tp.system.prompt('Fecha inicio (YYYY-MM-DD)') %>"
fecha_fin: "<% tp.system.prompt('Fecha fin (YYYY-MM-DD)') %>"
tags: [pi]
---

# PI {{VALUE:pi}} — {{VALUE:proyecto}}

| Campo | Valor |
|-------|-------|
| **Proyecto** | [[{{VALUE:proyecto}}]] |
| **Período** | <% tp.frontmatter.fecha_inicio %> → <% tp.frontmatter.fecha_fin %> |
| **Estado** | <% tp.frontmatter.status %> |

## Sprints

```dataview
TABLE without id
	file.link as "Sprint",
	status as "Estado",
	fecha_inicio as "Inicio",
	fecha_fin as "Fin"
FROM "proyectos/{{VALUE:proyecto}}/PI {{VALUE:pi}}"
WHERE tipo = "sprint"
SORT sprint ASC
```

## Objetivos del PI

- [ ]

## Notas
