---
tipo: contacto
nombre: "test"
siglum: "test"
empresa: "test"
rol: "test"
proyecto: "test"
email: "test"
telefono: "test"
tags: [contacto]
---

# test

| Campo | Valor |
|-------|-------|
| **Siglum** | <% tp.system.prompt('Siglum / alias') %> |
| **Empresa** | <% tp.system.prompt('Empresa') %> |
| **Rol** | <% tp.system.prompt('Rol en empresa') %> |
| **Proyecto** | [[<% tp.system.prompt('Proyecto') %>]] |
| **Email** | <% tp.system.prompt('Email') %> |
| **Teléfono** | <% tp.system.prompt('Teléfono') %> |

## Notas
