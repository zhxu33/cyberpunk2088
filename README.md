[Initial Plan](https://docs.google.com/document/d/1TuI_5MxxG3TNvrD7Z8iwSdKDze4Wr04ZUydlNR9okWQ/edit?usp=sharing)

[Project Document](https://github.com/zhxu33/battle-hero/blob/main/ProjectDocument.md)

## notes of collision
| CollisionBox                     | layer | mask |
|:--------------------------------:|:-----:|:----:|
|character                         |   1   |   1  |
|character Melee HitBox            |   NA  |   2  |
|character HurtBox                 |   3   |   NA |
|enemy                             |   1   |   1  |
|enemy Melee HitBox                |   NA  |   3  |
|enemy HurtBox                     |   2   |   NA |