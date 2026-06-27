---
tipo: contacto
nombre: "{{VALUE}}"
siglum: "<% tp.system.prompt('Siglum / alias') %>"
empresa: "<% tp.system.prompt('Empresa') %>"
rol: "<% tp.system.prompt('Rol en empresa') %>"
proyecto: "<% tp.system.prompt('Proyecto') %>"
email: "<% tp.system.prompt('Email') %>"
telefono: "<% tp.system.prompt('Teléfono') %>"
tags: [contacto]
---

# {{VALUE}}

| Campo | Valor |
|-------|-------|
| **Siglum** | <% tp.frontmatter.siglum %> |
| **Empresa** | <% tp.frontmatter.empresa %> |
| **Rol** | <% tp.frontmatter.rol %> |
| **Proyecto** | [[<% tp.frontmatter.proyecto %>]] |
| **Email** | <% tp.frontmatter.email %> |
| **Teléfono** | <% tp.frontmatter.telefono %> |

## Notas
