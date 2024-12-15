;========================================================================
; Этот блок реализует логику обмена информацией с графической оболочкой,
; а также механизм остановки и повторного пуска машины вывода
; Русский текст в комментариях разрешён!

(deftemplate ioproxy  ; шаблон факта-посредника для обмена информацией с GUI
	(slot fact-id)        ; теоретически тут id факта для изменения
	(multislot questions)   ; возможные ответы
	(multislot messages)  ; исходящие сообщения
	(slot reaction)       ; возможные ответы пользователя
	(slot value)          ; выбор пользователя
	(slot restore)        ; забыл зачем это поле
        (multislot answers)
)

; Собственно экземпляр факта ioproxy
(deffacts proxy-fact
	(ioproxy
		(fact-id 0112) ; это поле пока что не задействовано
		(value none)   ; значение пустое
		(messages)     ; мультислот messages изначально пуст
		(questions)
	)
)

(defrule clear-messages
	(declare (salience 90))
	?clear-msg-flg <- (clearmessage)
	?proxy <- (ioproxy)
	=>
	(modify ?proxy (messages))
	(retract ?clear-msg-flg)
	(printout t "Messages cleared ..." crlf)
)

(defrule set-output-and-halt
	(declare (salience 99))
	?current-message <- (sendmessagehalt ?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(printout t "Message set : " ?new-msg " ... halting ..." crlf)
	(modify ?proxy (messages ?new-msg))
	(retract ?current-message)
	(halt)
)

(defrule set-output-and-proceed
	(declare (salience 100))
	?current-message <- (sendmessage ?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(printout t "Message set : " ?new-msg " ... halting ..." crlf)
	(modify ?proxy (messages $?msg-list ?new-msg))
	(retract ?current-message)
)

(deftemplate question
    (slot value)
    (slot type)
)

(defrule set-question-and-halt
    (declare (salience 102))
    ?q <- (question (value ?val))
    ?proxy <- (ioproxy)
    =>
    (modify ?proxy (questions ?val))
    (retract ?q)
    (halt)
)

(defrule clear-questions
    (declare (salience 101))
    ?proxy <- (ioproxy (questions $?question-list&:(not(eq(length$ ?question-list) 0))))
    =>
    (modify ?proxy (questions))
)

;======================================================================================
(deftemplate input-question
	(multislot name)
)
(deftemplate possible-fact
	(multislot name)
)
(deftemplate fact
    (multislot name)
)

(deftemplate target
    (multislot name)
)

(defrule match-facts
	(declare (salience 9))
	(possible-fact (name ?val))
	?q <- (input-question (name ?n&?val))
	=>
	(retract ?q)
	(assert (fact (name ?val)))
)

(defrule match-target
    (declare (salience 10))
    (target (name ?val))
    (fact (name ?n&?val))
    =>
    (do-for-all-facts ((?f fact)) TRUE (retract ?f))
    (assert (sendmessage "Целевой факт найден, стоп"))
)

;=====================================================================================

(deffacts possible-facts
(possible-fact (name "Battlefield"))
(possible-fact (name "Battlefield 2042"))
(possible-fact (name "Battlefield 1"))
(possible-fact (name "Lethal Company"))
(possible-fact (name "Stanley Parable"))
(possible-fact (name "Team Fortress 2"))
(possible-fact (name "Overwatch"))
(possible-fact (name "Counter Strike 1.6"))
(possible-fact (name "Counter Strike 2"))
(possible-fact (name "Stardew Valley"))
(possible-fact (name "Minecraft"))
(possible-fact (name "Terraria"))
(possible-fact (name "Cuphead"))
(possible-fact (name "The Long Dark"))
(possible-fact (name "Chronoheart"))
(possible-fact (name "Civilization"))
(possible-fact (name "Hearts of Iron"))
(possible-fact (name "XCOM"))
(possible-fact (name "Heroes of Might and Magic"))
(possible-fact (name "Starcraft"))
(possible-fact (name "Skyrim"))
(possible-fact (name "Factorio"))
(possible-fact (name "OSU"))
(possible-fact (name "Counter Strike"))
(possible-fact (name "League of Legends"))
(possible-fact (name "Dark Souls"))
(possible-fact (name "Ghost of Tsushima"))
(possible-fact (name "Fortnite"))
(possible-fact (name "Among Us"))
(possible-fact (name "Apex Legends"))
(possible-fact (name "Cyberpunk 2077"))
(possible-fact (name "The Witcher 3"))
(possible-fact (name "Hollow Knight"))
(possible-fact (name "Darkest Dungeon"))
(possible-fact (name "Baldur's Gate 3"))
(possible-fact (name "The Sims 4"))
(possible-fact (name "Fallout Shelter"))
(possible-fact (name "Вид от 1-го лица"))
(possible-fact (name "Вид от 3-го лица"))
(possible-fact (name "Реалистичная графика"))
(possible-fact (name "Пиксельная графика"))
(possible-fact (name "3D"))
(possible-fact (name "2D"))
(possible-fact (name "Разрушаемость"))
(possible-fact (name "Вид сверху"))
(possible-fact (name "Вид сбоку"))
(possible-fact (name "Реалистичная 2.5D"))
(possible-fact (name "Воксельная графика"))
(possible-fact (name "Ритм-игра"))
(possible-fact (name "Шутер"))
(possible-fact (name "Платформер"))
(possible-fact (name "Стратегия"))
(possible-fact (name "Головоломка"))
(possible-fact (name "RPG"))
(possible-fact (name "Песочница"))
(possible-fact (name "Казуальная"))
(possible-fact (name "Хоррор"))
(possible-fact (name "Хоррор на выживание"))
(possible-fact (name "Пошаговая"))
(possible-fact (name "В реальном времени"))
(possible-fact (name "MOBA"))
(possible-fact (name "Рогалик"))
(possible-fact (name "Экшен-RPG"))
(possible-fact (name "Симулятор"))
(possible-fact (name "Детективная"))
(possible-fact (name "Классовый шутер"))
(possible-fact (name "Выживание"))
(possible-fact (name "Рыбалка"))
(possible-fact (name "Управление ресурсами"))
(possible-fact (name "Стелс"))
(possible-fact (name "Исследование"))
(possible-fact (name "Крафт"))
(possible-fact (name "Постройка базы"))
(possible-fact (name "Карточные бои"))
(possible-fact (name "Микроменеджмент"))
(possible-fact (name "Фэнтези"))
(possible-fact (name "Фантастика"))
(possible-fact (name "Исторический"))
(possible-fact (name "Ретро"))
(possible-fact (name "Дизельпанк"))
(possible-fact (name "Стимпанк"))
(possible-fact (name "Онлайн"))
(possible-fact (name "Офлайн"))
(possible-fact (name "Кооператив"))
(possible-fact (name "Соревновательный"))
(possible-fact (name "Triple A"))
(possible-fact (name "Инди"))
(possible-fact (name "Сюжетная"))
(possible-fact (name "Новая"))
(possible-fact (name "Старая"))
(possible-fact (name "Бесплатная"))
(possible-fact (name "Платная"))
(possible-fact (name "Сложная"))
(possible-fact (name "Одиночная игра"))
(possible-fact (name "Многопользовательская"))
(possible-fact (name "Бесплатные дополнения"))
(possible-fact (name "Затягивающая"))
(possible-fact (name "Плохая"))
(possible-fact (name "Классика"))
)
(defrule rule3
(fact (name "Шутер"))
(not (exists (fact (name "3D"))))
=>
(assert (fact (name "3D")))
(assert (sendmessage "Шутер -> 3D")))
(defrule rule5
(fact (name "Платформер"))
(not (exists (fact (name "2D"))))
=>
(assert (fact (name "2D")))
(assert (sendmessage "Платформер -> 2D")))
(defrule rule7
(fact (name "Шутер"))
(fact (name "Стратегия"))
(not (exists (fact (name "Классовый шутер"))))
=>
(assert (fact (name "Классовый шутер")))
(assert (sendmessage "Шутер, Стратегия -> Классовый шутер")))
(defrule rule9
(fact (name "Рыбалка"))
(not (exists (fact (name "Управление ресурсами"))))
=>
(assert (fact (name "Управление ресурсами")))
(assert (sendmessage "Рыбалка -> Управление ресурсами")))
(defrule rule11
(fact (name "Пиксельная графика"))
(not (exists (fact (name "2D"))))
=>
(assert (fact (name "2D")))
(assert (sendmessage "Пиксельная графика -> 2D")))
(defrule rule13
(fact (name "2D"))
(not (exists (fact (name "Вид сбоку"))))
=>
(assert (fact (name "Вид сбоку")))
(assert (sendmessage "2D -> Вид сбоку")))
(defrule rule15
(fact (name "2D"))
(not (exists (fact (name "Вид сверху"))))
=>
(assert (fact (name "Вид сверху")))
(assert (sendmessage "2D -> Вид сверху")))
(defrule rule17
(fact (name "Шутер"))
(not (exists (fact (name "Разрушаемость"))))
=>
(assert (fact (name "Разрушаемость")))
(assert (sendmessage "Шутер -> Разрушаемость")))
(defrule rule19
(fact (name "Старая"))
(not (exists (fact (name "Классика"))))
=>
(assert (fact (name "Классика")))
(assert (sendmessage "Старая -> Классика")))
(defrule rule21
(fact (name "Вид от 1-го лица"))
(not (exists (fact (name "3D"))))
=>
(assert (fact (name "3D")))
(assert (sendmessage "Вид от 1-го лица -> 3D")))
(defrule rule23
(fact (name "Вид от 3-го лица"))
(not (exists (fact (name "3D"))))
=>
(assert (fact (name "3D")))
(assert (sendmessage "Вид от 3-го лица -> 3D")))
(defrule rule25
(fact (name "Triple A"))
(fact (name "Новая"))
(not (exists (fact (name "Плохая"))))
=>
(assert (fact (name "Плохая")))
(assert (sendmessage "Triple A, Новая -> Плохая")))
(defrule rule27
(fact (name "Хоррор"))
(fact (name "Выживание"))
(not (exists (fact (name "Хоррор на выживание"))))
=>
(assert (fact (name "Хоррор на выживание")))
(assert (sendmessage "Хоррор, Выживание -> Хоррор на выживание")))
(defrule rule29
(fact (name "Кооператив"))
(not (exists (fact (name "Онлайн"))))
=>
(assert (fact (name "Онлайн")))
(assert (sendmessage "Кооператив -> Онлайн")))
(defrule rule31
(fact (name "Соревновательный"))
(not (exists (fact (name "Сложная"))))
=>
(assert (fact (name "Сложная")))
(assert (sendmessage "Соревновательный -> Сложная")))
(defrule rule33
(fact (name "Экшен-RPG"))
(not (exists (fact (name "3D"))))
=>
(assert (fact (name "3D")))
(assert (sendmessage "Экшен-RPG -> 3D")))
(defrule rule35
(fact (name "Рогалик"))
(not (exists (fact (name "Сложная"))))
=>
(assert (fact (name "Сложная")))
(assert (sendmessage "Рогалик -> Сложная")))
(defrule rule37
(fact (name "Многопользовательская"))
(not (exists (fact (name "Онлайн"))))
=>
(assert (fact (name "Онлайн")))
(assert (sendmessage "Многопользовательская -> Онлайн")))
(defrule rule39
(fact (name "Одиночная игра"))
(not (exists (fact (name "Офлайн"))))
=>
(assert (fact (name "Офлайн")))
(assert (sendmessage "Одиночная игра -> Офлайн")))
(defrule rule41
(fact (name "MOBA"))
(fact (name "Многопользовательская"))
(not (exists (fact (name "Соревновательный"))))
=>
(assert (fact (name "Соревновательный")))
(assert (sendmessage "MOBA, Многопользовательская -> Соревновательный")))
(defrule rule43
(fact (name "Ретро"))
(not (exists (fact (name "Пиксельная графика"))))
=>
(assert (fact (name "Пиксельная графика")))
(assert (sendmessage "Ретро -> Пиксельная графика")))
(defrule rule45
(fact (name "Воксельная графика"))
(not (exists (fact (name "3D"))))
=>
(assert (fact (name "3D")))
(assert (sendmessage "Воксельная графика -> 3D")))
(defrule rule47
(fact (name "Стелс"))
(not (exists (fact (name "Исследование"))))
=>
(assert (fact (name "Исследование")))
(assert (sendmessage "Стелс -> Исследование")))
(defrule rule49
(fact (name "Исследование"))
(not (exists (fact (name "Сюжетная"))))
=>
(assert (fact (name "Сюжетная")))
(assert (sendmessage "Исследование -> Сюжетная")))
(defrule rule51
(fact (name "Сюжетная"))
(fact (name "Инди"))
(not (exists (fact (name "Затягивающая"))))
=>
(assert (fact (name "Затягивающая")))
(assert (sendmessage "Сюжетная, Инди -> Затягивающая")))
(defrule rule53
(fact (name "Хоррор на выживание"))
(fact (name "Сложная"))
(not (exists (fact (name "Хоррор"))))
=>
(assert (fact (name "Хоррор")))
(assert (sendmessage "Хоррор на выживание, Сложная -> Хоррор")))
(defrule rule55
(fact (name "Кооператив"))
(fact (name "Хоррор на выживание"))
(not (exists (fact (name "3D"))))
=>
(assert (fact (name "3D")))
(assert (sendmessage "Кооператив, Хоррор на выживание -> 3D")))
(defrule rule57
(fact (name "Хоррор на выживание"))
(not (exists (fact (name "Выживание"))))
=>
(assert (fact (name "Выживание")))
(assert (sendmessage "Хоррор на выживание -> Выживание")))
(defrule rule62
(fact (name "Шутер"))
(fact (name "Разрушаемость"))
(fact (name "3D"))
(fact (name "Онлайн"))
(not (exists (fact (name "Battlefield"))))
=>
(assert (fact (name "Battlefield")))
(assert (sendmessage "Шутер, Разрушаемость, 3D, Онлайн -> Battlefield")))
(defrule rule64
(fact (name "Battlefield"))
(fact (name "Плохая"))
(not (exists (fact (name "Battlefield 2042"))))
=>
(assert (fact (name "Battlefield 2042")))
(assert (sendmessage "Battlefield, Плохая -> Battlefield 2042")))
(defrule rule66
(fact (name "Battlefield"))
(fact (name "Исторический"))
(not (exists (fact (name "Battlefield 1"))))
=>
(assert (fact (name "Battlefield 1")))
(assert (sendmessage "Battlefield, Исторический -> Battlefield 1")))
(defrule rule68
(fact (name "3D"))
(fact (name "Онлайн"))
(fact (name "Хоррор на выживание"))
(not (exists (fact (name "Lethal Company"))))
=>
(assert (fact (name "Lethal Company")))
(assert (sendmessage "3D, Онлайн, Хоррор на выживание -> Lethal Company")))
(defrule rule70
(fact (name "Сюжетная"))
(fact (name "Офлайн"))
(fact (name "3D"))
(fact (name "Головоломка"))
(not (exists (fact (name "Stanley Parable"))))
=>
(assert (fact (name "Stanley Parable")))
(assert (sendmessage "Сюжетная, Офлайн, 3D, Головоломка -> Stanley Parable")))
(defrule rule72
(fact (name "Классовый шутер"))
(fact (name "3D"))
(fact (name "Онлайн"))
(fact (name "Классика"))
(not (exists (fact (name "Team Fortress 2"))))
=>
(assert (fact (name "Team Fortress 2")))
(assert (sendmessage "Классовый шутер, 3D, Онлайн, Классика -> Team Fortress 2")))
(defrule rule74
(fact (name "Классовый шутер"))
(fact (name "3D"))
(fact (name "Онлайн"))
(fact (name "Плохая"))
(not (exists (fact (name "Overwatch"))))
=>
(assert (fact (name "Overwatch")))
(assert (sendmessage "Классовый шутер, 3D, Онлайн, Плохая -> Overwatch")))
(defrule rule76
(fact (name "Шутер"))
(fact (name "3D"))
(fact (name "Онлайн"))
(fact (name "Соревновательный"))
(not (exists (fact (name "Counter Strike"))))
=>
(assert (fact (name "Counter Strike")))
(assert (sendmessage "Шутер, 3D, Онлайн, Соревновательный -> Counter Strike")))
(defrule rule78
(fact (name "Counter Strike"))
(fact (name "Старая"))
(not (exists (fact (name "Counter Strike 1.6"))))
=>
(assert (fact (name "Counter Strike 1.6")))
(assert (sendmessage "Counter Strike, Старая -> Counter Strike 1.6")))
(defrule rule80
(fact (name "Counter Strike"))
(fact (name "Новая"))
(not (exists (fact (name "Counter Strike 2"))))
=>
(assert (fact (name "Counter Strike 2")))
(assert (sendmessage "Counter Strike, Новая -> Counter Strike 2")))
(defrule rule82
(fact (name "RPG"))
(fact (name "Казуальная"))
(fact (name "Вид сверху"))
(fact (name "Инди"))
(not (exists (fact (name "Stardew Valley"))))
=>
(assert (fact (name "Stardew Valley")))
(assert (sendmessage "RPG, Казуальная, Вид сверху, Инди -> Stardew Valley")))
(defrule rule84
(fact (name "Песочница"))
(fact (name "3D"))
(fact (name "Управление ресурсами"))
(not (exists (fact (name "Minecraft"))))
=>
(assert (fact (name "Minecraft")))
(assert (sendmessage "Песочница, 3D, Управление ресурсами -> Minecraft")))
(defrule rule86
(fact (name "Песочница"))
(fact (name "2D"))
(fact (name "RPG"))
(fact (name "Управление ресурсами"))
(not (exists (fact (name "Terraria"))))
=>
(assert (fact (name "Terraria")))
(assert (sendmessage "Песочница, 2D, RPG, Управление ресурсами -> Terraria")))
(defrule rule88
(fact (name "Платформер"))
(fact (name "Вид сбоку"))
(fact (name "Сложная"))
(fact (name "Офлайн"))
(not (exists (fact (name "Cuphead"))))
=>
(assert (fact (name "Cuphead")))
(assert (sendmessage "Платформер, Вид сбоку, Сложная, Офлайн -> Cuphead")))
(defrule rule90
(fact (name "Выживание"))
(fact (name "3D"))
(fact (name "Управление ресурсами"))
(not (exists (fact (name "The Long Dark"))))
=>
(assert (fact (name "The Long Dark")))
(assert (sendmessage "Выживание, 3D, Управление ресурсами -> The Long Dark")))
(defrule rule92
(fact (name "Классика"))
(fact (name "Вид сбоку"))
(fact (name "Ритм-игра"))
(fact (name "Сложная"))
(not (exists (fact (name "Chronoheart"))))
=>
(assert (fact (name "Chronoheart")))
(assert (sendmessage "Классика, Вид сбоку, Ритм-игра, Сложная -> Chronoheart")))
(defrule rule94
(fact (name "Стратегия"))
(fact (name "Пошаговая"))
(fact (name "Исторический"))
(not (exists (fact (name "Civilization"))))
=>
(assert (fact (name "Civilization")))
(assert (sendmessage "Стратегия, Пошаговая, Исторический -> Civilization")))
(defrule rule96
(fact (name "Стратегия"))
(fact (name "В реальном времени"))
(fact (name "Исторический"))
(not (exists (fact (name "Hearts of Iron"))))
=>
(assert (fact (name "Hearts of Iron")))
(assert (sendmessage "Стратегия, В реальном времени, Исторический -> Hearts of Iron")))
(defrule rule98
(fact (name "Стратегия"))
(fact (name "Пошаговая"))
(fact (name "Фантастика"))
(not (exists (fact (name "XCOM"))))
=>
(assert (fact (name "XCOM")))
(assert (sendmessage "Стратегия, Пошаговая, Фантастика -> XCOM")))
(defrule rule100
(fact (name "Стратегия"))
(fact (name "Классика"))
(fact (name "Старая"))
(not (exists (fact (name "Heroes of Might and Magic"))))
=>
(assert (fact (name "Heroes of Might and Magic")))
(assert (sendmessage "Стратегия, Классика, Старая -> Heroes of Might and Magic")))
(defrule rule102
(fact (name "Стратегия"))
(fact (name "Соревновательный"))
(fact (name "В реальном времени"))
(not (exists (fact (name "Starcraft"))))
=>
(assert (fact (name "Starcraft")))
(assert (sendmessage "Стратегия, Соревновательный, В реальном времени -> Starcraft")))
(defrule rule104
(fact (name "3D"))
(fact (name "RPG"))
(fact (name "Фэнтези"))
(fact (name "Сюжетная"))
(fact (name "Офлайн"))
(not (exists (fact (name "Skyrim"))))
=>
(assert (fact (name "Skyrim")))
(assert (sendmessage "3D, RPG, Фэнтези, Сюжетная, Офлайн -> Skyrim")))
(defrule rule106
(fact (name "Управление ресурсами"))
(fact (name "Вид сверху"))
(fact (name "Сложная"))
(fact (name "Фантастика"))
(not (exists (fact (name "Factorio"))))
=>
(assert (fact (name "Factorio")))
(assert (sendmessage "Управление ресурсами, Вид сверху, Сложная, Фантастика -> Factorio")))
(defrule rule108
(fact (name "Ритм-игра"))
(fact (name "Сложная"))
(fact (name "Бесплатная"))
(not (exists (fact (name "OSU"))))
=>
(assert (fact (name "OSU")))
(assert (sendmessage "Ритм-игра, Сложная, Бесплатная -> OSU")))
(defrule rule110
(fact (name "Экшен-RPG"))
(fact (name "3D"))
(fact (name "Сюжетная"))
(not (exists (fact (name "Ghost of Tsushima"))))
=>
(assert (fact (name "Ghost of Tsushima")))
(assert (sendmessage "Экшен-RPG, 3D, Сюжетная -> Ghost of Tsushima")))
(defrule rule112
(fact (name "Рогалик"))
(fact (name "Вид сбоку"))
(fact (name "Сложная"))
(not (exists (fact (name "Darkest Dungeon"))))
=>
(assert (fact (name "Darkest Dungeon")))
(assert (sendmessage "Рогалик, Вид сбоку, Сложная -> Darkest Dungeon")))
(defrule rule114
(fact (name "Затягивающая"))
(fact (name "Бесплатные дополнения"))
(not (exists (fact (name "Fortnite"))))
=>
(assert (fact (name "Fortnite")))
(assert (sendmessage "Затягивающая, Бесплатные дополнения -> Fortnite")))
(defrule rule116
(fact (name "Фэнтези"))
(fact (name "Пошаговая"))
(fact (name "RPG"))
(not (exists (fact (name "Baldur's Gate 3"))))
=>
(assert (fact (name "Baldur's Gate 3")))
(assert (sendmessage "Фэнтези, Пошаговая, RPG -> Baldur's Gate 3")))
(defrule rule118
(fact (name "MOBA"))
(fact (name "Онлайн"))
(fact (name "Соревновательный"))
(not (exists (fact (name "League of Legends"))))
=>
(assert (fact (name "League of Legends")))
(assert (sendmessage "MOBA, Онлайн, Соревновательный -> League of Legends")))
(defrule rule120
(fact (name "Стратегия"))
(fact (name "Фэнтези"))
(fact (name "Пошаговая"))
(not (exists (fact (name "Heroes of Might and Magic"))))
=>
(assert (fact (name "Heroes of Might and Magic")))
(assert (sendmessage "Стратегия, Фэнтези, Пошаговая -> Heroes of Might and Magic")))
(defrule rule122
(fact (name "Одиночная игра"))
(fact (name "Фэнтези"))
(fact (name "RPG"))
(not (exists (fact (name "The Witcher 3"))))
=>
(assert (fact (name "The Witcher 3")))
(assert (sendmessage "Одиночная игра, Фэнтези, RPG -> The Witcher 3")))
(defrule rule124
(fact (name "Симулятор"))
(fact (name "Затягивающая"))
(fact (name "Постройка базы"))
(not (exists (fact (name "The Sims 4"))))
=>
(assert (fact (name "The Sims 4")))
(assert (sendmessage "Симулятор, Затягивающая, Постройка базы -> The Sims 4")))
(defrule rule126
(fact (name "Экшен-RPG"))
(fact (name "Реалистичная графика"))
(fact (name "3D"))
(not (exists (fact (name "Cyberpunk 2077"))))
=>
(assert (fact (name "Cyberpunk 2077")))
(assert (sendmessage "Экшен-RPG, Реалистичная графика, 3D -> Cyberpunk 2077")))
(defrule rule128
(fact (name "Крафт"))
(fact (name "Постройка базы"))
(fact (name "Затягивающая"))
(not (exists (fact (name "Minecraft"))))
=>
(assert (fact (name "Minecraft")))
(assert (sendmessage "Крафт, Постройка базы, Затягивающая -> Minecraft")))
(defrule rule130
(fact (name "Постройка базы"))
(fact (name "Симулятор"))
(fact (name "Онлайн"))
(not (exists (fact (name "Fallout Shelter"))))
=>
(assert (fact (name "Fallout Shelter")))
(assert (sendmessage "Постройка базы, Симулятор, Онлайн -> Fallout Shelter")))
(defrule rule132
(fact (name "MOBA"))
(fact (name "Реалистичная графика"))
(fact (name "Соревновательный"))
(not (exists (fact (name "Apex Legends"))))
=>
(assert (fact (name "Apex Legends")))
(assert (sendmessage "MOBA, Реалистичная графика, Соревновательный -> Apex Legends")))
(defrule rule134
(fact (name "Сложная"))
(fact (name "Сложная"))
(fact (name "Платформер"))
(fact (name "Офлайн"))
(not (exists (fact (name "Hollow Knight"))))
=>
(assert (fact (name "Hollow Knight")))
(assert (sendmessage "Сложная, Сложная, Платформер, Офлайн -> Hollow Knight")))
(defrule rule136
(fact (name "3D"))
(fact (name "Вид от 3-го лица"))
(fact (name "Сложная"))
(not (exists (fact (name "Dark Souls"))))
=>
(assert (fact (name "Dark Souls")))
(assert (sendmessage "3D, Вид от 3-го лица, Сложная -> Dark Souls")))
(defrule rule138
(fact (name "Онлайн"))
(fact (name "Детективная"))
(fact (name "Вид сверху"))
(not (exists (fact (name "Among Us"))))
=>
(assert (fact (name "Among Us")))
(assert (sendmessage "Онлайн, Детективная, Вид сверху -> Among Us")))