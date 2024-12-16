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
    ?current-message <- (sendmessagehalt ?new-msg ?conf)
    ?proxy <- (ioproxy (messages $?msg-list))
    =>
    (bind ?formatted-msg (str-cat ?new-msg " (Confidence: " ?conf ")")) ; Format the message
    (printout t "Message set: " ?formatted-msg " ... halting ..." crlf)
    (modify ?proxy (messages ?formatted-msg))
    (retract ?current-message)
    (halt)
)

(defrule set-output-and-proceed
    (declare (salience 100))
    ?current-message <- (sendmessage ?new-msg ?conf)
    ?proxy <- (ioproxy (messages $?msg-list))
    =>
    (bind ?formatted-msg (str-cat ?new-msg " (Confidence: " ?conf ")")) ; Format the message
    (printout t "Message set: " ?formatted-msg " ... proceeding ..." crlf)
    (modify ?proxy (messages $?msg-list ?formatted-msg))
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
	(slot confidence (type NUMBER))
)
(deftemplate possible-fact
	(multislot name)
)
(deftemplate fact
    (multislot name)
	(slot confidence (type NUMBER))
)

(deftemplate target
    (multislot name)
)

(defrule match-facts
	(declare (salience 9))
	(possible-fact (name ?val))
	?q <- (input-question (name ?n&?val) (confidence ?c))
	=>
	(retract ?q)
	(assert (fact (name ?val) (confidence ?c)))
)

(defrule match-target
    (declare (salience 10))
    (target (name ?val))
    (fact (name ?n&?val))
    =>
    (do-for-all-facts ((?f fact)) TRUE (retract ?f))
    (assert (sendmessage "Целевой факт найден, стоп"))
)

(deffunction calculateNewConfidence (?minConfidence ?ruleConfidence)
    (if (or (< ?minConfidence 0) (< ?ruleConfidence 0))
        then (return (min ?minConfidence ?ruleConfidence))
        else (return (* ?minConfidence ?ruleConfidence)))
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
(possible-fact (name "Ужасы"))
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
(defglobal ?*confidence-rule3* = 0.9)
(defglobal ?*confidence-rule5* = 0.9)
(defglobal ?*confidence-rule7* = 0.9)
(defglobal ?*confidence-rule9* = 0.9)
(defglobal ?*confidence-rule11* = 0.9)
(defglobal ?*confidence-rule13* = 0.9)
(defglobal ?*confidence-rule15* = 0.9)
(defglobal ?*confidence-rule17* = 0.9)
(defglobal ?*confidence-rule19* = 0.9)
(defglobal ?*confidence-rule21* = 0.9)
(defglobal ?*confidence-rule23* = 0.9)
(defglobal ?*confidence-rule25* = 0.9)
(defglobal ?*confidence-rule27* = 0.9)
(defglobal ?*confidence-rule29* = 0.9)
(defglobal ?*confidence-rule31* = 0.9)
(defglobal ?*confidence-rule33* = 0.9)
(defglobal ?*confidence-rule35* = 0.9)
(defglobal ?*confidence-rule37* = 0.9)
(defglobal ?*confidence-rule39* = 0.9)
(defglobal ?*confidence-rule41* = 0.9)
(defglobal ?*confidence-rule43* = 0.9)
(defglobal ?*confidence-rule45* = 0.9)
(defglobal ?*confidence-rule47* = 0.9)
(defglobal ?*confidence-rule49* = 0.9)
(defglobal ?*confidence-rule51* = 0.9)
(defglobal ?*confidence-rule53* = 0.9)
(defglobal ?*confidence-rule55* = 0.9)
(defglobal ?*confidence-rule57* = 0.9)
(defglobal ?*confidence-rule62* = 0.9)
(defglobal ?*confidence-rule64* = 0.9)
(defglobal ?*confidence-rule66* = 0.9)
(defglobal ?*confidence-rule68* = 0.9)
(defglobal ?*confidence-rule70* = 0.9)
(defglobal ?*confidence-rule72* = 0.9)
(defglobal ?*confidence-rule74* = 0.9)
(defglobal ?*confidence-rule76* = 0.9)
(defglobal ?*confidence-rule78* = 0.9)
(defglobal ?*confidence-rule80* = 0.9)
(defglobal ?*confidence-rule82* = 0.9)
(defglobal ?*confidence-rule84* = 0.9)
(defglobal ?*confidence-rule86* = 0.9)
(defglobal ?*confidence-rule88* = 0.9)
(defglobal ?*confidence-rule90* = 0.9)
(defglobal ?*confidence-rule92* = 0.9)
(defglobal ?*confidence-rule94* = 0.9)
(defglobal ?*confidence-rule96* = 0.9)
(defglobal ?*confidence-rule98* = 0.9)
(defglobal ?*confidence-rule100* = 0.9)
(defglobal ?*confidence-rule102* = 0.9)
(defglobal ?*confidence-rule104* = 0.9)
(defglobal ?*confidence-rule106* = 0.9)
(defglobal ?*confidence-rule108* = 0.9)
(defglobal ?*confidence-rule110* = 0.9)
(defglobal ?*confidence-rule112* = 0.9)
(defglobal ?*confidence-rule114* = 0.9)
(defglobal ?*confidence-rule116* = 0.9)
(defglobal ?*confidence-rule118* = 0.9)
(defglobal ?*confidence-rule120* = 0.9)
(defglobal ?*confidence-rule122* = 0.9)
(defglobal ?*confidence-rule124* = 0.9)
(defglobal ?*confidence-rule126* = 0.9)
(defglobal ?*confidence-rule128* = 0.9)
(defglobal ?*confidence-rule130* = 0.9)
(defglobal ?*confidence-rule132* = 0.9)
(defglobal ?*confidence-rule134* = 0.9)
(defglobal ?*confidence-rule136* = 0.9)
(defglobal ?*confidence-rule138* = 0.9)

(defrule rule3
(fact (name "Шутер") (confidence ?c1))
(not (exists (fact (name "3D"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule3*))
(assert (fact (name "3D") (confidence ?newConf)))
(assert (sendmessage "Шутер -> 3D" ?newConf)))
(defrule rule5
(fact (name "Платформер") (confidence ?c1))
(not (exists (fact (name "2D"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule5*))
(assert (fact (name "2D") (confidence ?newConf)))
(assert (sendmessage "Платформер -> 2D" ?newConf)))
(defrule rule7
(fact (name "Шутер") (confidence ?c1))
(fact (name "Стратегия") (confidence ?c2))
(not (exists (fact (name "Классовый шутер"))))
=>
(bind ?minConf (min ?c1 ?c2))
(bind ?newConf (* ?minConf ?*confidence-rule7*))
(assert (fact (name "Классовый шутер") (confidence ?newConf)))
(assert (sendmessage "Шутер, Стратегия -> Классовый шутер" ?newConf)))
(defrule rule9
(fact (name "Рыбалка") (confidence ?c1))
(not (exists (fact (name "Управление ресурсами"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule9*))
(assert (fact (name "Управление ресурсами") (confidence ?newConf)))
(assert (sendmessage "Рыбалка -> Управление ресурсами" ?newConf)))
(defrule rule11
(fact (name "Пиксельная графика") (confidence ?c1))
(not (exists (fact (name "2D"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule11*))
(assert (fact (name "2D") (confidence ?newConf)))
(assert (sendmessage "Пиксельная графика -> 2D" ?newConf)))
(defrule rule13
(fact (name "2D") (confidence ?c1))
(not (exists (fact (name "Вид сбоку"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule13*))
(assert (fact (name "Вид сбоку") (confidence ?newConf)))
(assert (sendmessage "2D -> Вид сбоку" ?newConf)))
(defrule rule15
(fact (name "2D") (confidence ?c1))
(not (exists (fact (name "Вид сверху"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule15*))
(assert (fact (name "Вид сверху") (confidence ?newConf)))
(assert (sendmessage "2D -> Вид сверху" ?newConf)))
(defrule rule17
(fact (name "Шутер") (confidence ?c1))
(not (exists (fact (name "Разрушаемость"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule17*))
(assert (fact (name "Разрушаемость") (confidence ?newConf)))
(assert (sendmessage "Шутер -> Разрушаемость" ?newConf)))
(defrule rule19
(fact (name "Старая") (confidence ?c1))
(not (exists (fact (name "Классика"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule19*))
(assert (fact (name "Классика") (confidence ?newConf)))
(assert (sendmessage "Старая -> Классика" ?newConf)))
(defrule rule21
(fact (name "Вид от 1-го лица") (confidence ?c1))
(not (exists (fact (name "3D"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule21*))
(assert (fact (name "3D") (confidence ?newConf)))
(assert (sendmessage "Вид от 1-го лица -> 3D" ?newConf)))
(defrule rule23
(fact (name "Вид от 3-го лица") (confidence ?c1))
(not (exists (fact (name "3D"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule23*))
(assert (fact (name "3D") (confidence ?newConf)))
(assert (sendmessage "Вид от 3-го лица -> 3D" ?newConf)))
(defrule rule25
(fact (name "Triple A") (confidence ?c1))
(fact (name "Новая") (confidence ?c2))
(not (exists (fact (name "Плохая"))))
=>
(bind ?minConf (min ?c1 ?c2))
(bind ?newConf (* ?minConf ?*confidence-rule25*))
(assert (fact (name "Плохая") (confidence ?newConf)))
(assert (sendmessage "Triple A, Новая -> Плохая" ?newConf)))
(defrule rule27
(fact (name "Ужасы") (confidence ?c1))
(fact (name "Выживание") (confidence ?c2))
(not (exists (fact (name "Хоррор на выживание"))))
=>
(bind ?minConf (min ?c1 ?c2))
(bind ?newConf (* ?minConf ?*confidence-rule27*))
(assert (fact (name "Хоррор на выживание") (confidence ?newConf)))
(assert (sendmessage "Ужасы, Выживание -> Хоррор на выживание" ?newConf)))
(defrule rule29
(fact (name "Кооператив") (confidence ?c1))
(not (exists (fact (name "Онлайн"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule29*))
(assert (fact (name "Онлайн") (confidence ?newConf)))
(assert (sendmessage "Кооператив -> Онлайн" ?newConf)))
(defrule rule31
(fact (name "Соревновательный") (confidence ?c1))
(not (exists (fact (name "Сложная"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule31*))
(assert (fact (name "Сложная") (confidence ?newConf)))
(assert (sendmessage "Соревновательный -> Сложная" ?newConf)))
(defrule rule33
(fact (name "Экшен-RPG") (confidence ?c1))
(not (exists (fact (name "3D"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule33*))
(assert (fact (name "3D") (confidence ?newConf)))
(assert (sendmessage "Экшен-RPG -> 3D" ?newConf)))
(defrule rule35
(fact (name "Рогалик") (confidence ?c1))
(not (exists (fact (name "Сложная"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule35*))
(assert (fact (name "Сложная") (confidence ?newConf)))
(assert (sendmessage "Рогалик -> Сложная" ?newConf)))
(defrule rule37
(fact (name "Многопользовательская") (confidence ?c1))
(not (exists (fact (name "Онлайн"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule37*))
(assert (fact (name "Онлайн") (confidence ?newConf)))
(assert (sendmessage "Многопользовательская -> Онлайн" ?newConf)))
(defrule rule39
(fact (name "Одиночная игра") (confidence ?c1))
(not (exists (fact (name "Офлайн"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule39*))
(assert (fact (name "Офлайн") (confidence ?newConf)))
(assert (sendmessage "Одиночная игра -> Офлайн" ?newConf)))
(defrule rule41
(fact (name "MOBA") (confidence ?c1))
(fact (name "Многопользовательская") (confidence ?c2))
(not (exists (fact (name "Соревновательный"))))
=>
(bind ?minConf (min ?c1 ?c2))
(bind ?newConf (* ?minConf ?*confidence-rule41*))
(assert (fact (name "Соревновательный") (confidence ?newConf)))
(assert (sendmessage "MOBA, Многопользовательская -> Соревновательный" ?newConf)))
(defrule rule43
(fact (name "Ретро") (confidence ?c1))
(not (exists (fact (name "Пиксельная графика"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule43*))
(assert (fact (name "Пиксельная графика") (confidence ?newConf)))
(assert (sendmessage "Ретро -> Пиксельная графика" ?newConf)))
(defrule rule45
(fact (name "Воксельная графика") (confidence ?c1))
(not (exists (fact (name "3D"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule45*))
(assert (fact (name "3D") (confidence ?newConf)))
(assert (sendmessage "Воксельная графика -> 3D" ?newConf)))
(defrule rule47
(fact (name "Стелс") (confidence ?c1))
(not (exists (fact (name "Исследование"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule47*))
(assert (fact (name "Исследование") (confidence ?newConf)))
(assert (sendmessage "Стелс -> Исследование" ?newConf)))
(defrule rule49
(fact (name "Исследование") (confidence ?c1))
(not (exists (fact (name "Сюжетная"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule49*))
(assert (fact (name "Сюжетная") (confidence ?newConf)))
(assert (sendmessage "Исследование -> Сюжетная" ?newConf)))
(defrule rule51
(fact (name "Сюжетная") (confidence ?c1))
(fact (name "Инди") (confidence ?c2))
(not (exists (fact (name "Затягивающая"))))
=>
(bind ?minConf (min ?c1 ?c2))
(bind ?newConf (* ?minConf ?*confidence-rule51*))
(assert (fact (name "Затягивающая") (confidence ?newConf)))
(assert (sendmessage "Сюжетная, Инди -> Затягивающая" ?newConf)))
(defrule rule53
(fact (name "Хоррор на выживание") (confidence ?c1))
(fact (name "Сложная") (confidence ?c2))
(not (exists (fact (name "Ужасы"))))
=>
(bind ?minConf (min ?c1 ?c2))
(bind ?newConf (* ?minConf ?*confidence-rule53*))
(assert (fact (name "Ужасы") (confidence ?newConf)))
(assert (sendmessage "Хоррор на выживание, Сложная -> Ужасы" ?newConf)))
(defrule rule55
(fact (name "Кооператив") (confidence ?c1))
(fact (name "Хоррор на выживание") (confidence ?c2))
(not (exists (fact (name "3D"))))
=>
(bind ?minConf (min ?c1 ?c2))
(bind ?newConf (* ?minConf ?*confidence-rule55*))
(assert (fact (name "3D") (confidence ?newConf)))
(assert (sendmessage "Кооператив, Хоррор на выживание -> 3D" ?newConf)))
(defrule rule57
(fact (name "Хоррор на выживание") (confidence ?c1))
(not (exists (fact (name "Выживание"))))
=>
(bind ?minConf (min ?c1))
(bind ?newConf (* ?minConf ?*confidence-rule57*))
(assert (fact (name "Выживание") (confidence ?newConf)))
(assert (sendmessage "Хоррор на выживание -> Выживание" ?newConf)))
(defrule rule62
(fact (name "Шутер") (confidence ?c1))
(fact (name "Разрушаемость") (confidence ?c2))
(fact (name "3D") (confidence ?c3))
(fact (name "Онлайн") (confidence ?c4))
(not (exists (fact (name "Battlefield"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3 ?c4))
(bind ?newConf (* ?minConf ?*confidence-rule62*))
(assert (fact (name "Battlefield") (confidence ?newConf)))
(assert (sendmessage "Шутер, Разрушаемость, 3D, Онлайн -> Battlefield" ?newConf)))
(defrule rule64
(fact (name "Battlefield") (confidence ?c1))
(fact (name "Плохая") (confidence ?c2))
(not (exists (fact (name "Battlefield 2042"))))
=>
(bind ?minConf (min ?c1 ?c2))
(bind ?newConf (* ?minConf ?*confidence-rule64*))
(assert (fact (name "Battlefield 2042") (confidence ?newConf)))
(assert (sendmessage "Battlefield, Плохая -> Battlefield 2042" ?newConf)))
(defrule rule66
(fact (name "Battlefield") (confidence ?c1))
(fact (name "Исторический") (confidence ?c2))
(not (exists (fact (name "Battlefield 1"))))
=>
(bind ?minConf (min ?c1 ?c2))
(bind ?newConf (* ?minConf ?*confidence-rule66*))
(assert (fact (name "Battlefield 1") (confidence ?newConf)))
(assert (sendmessage "Battlefield, Исторический -> Battlefield 1" ?newConf)))
(defrule rule68
(fact (name "3D") (confidence ?c1))
(fact (name "Онлайн") (confidence ?c2))
(fact (name "Хоррор на выживание") (confidence ?c3))
(not (exists (fact (name "Lethal Company"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule68*))
(assert (fact (name "Lethal Company") (confidence ?newConf)))
(assert (sendmessage "3D, Онлайн, Хоррор на выживание -> Lethal Company" ?newConf)))
(defrule rule70
(fact (name "Сюжетная") (confidence ?c1))
(fact (name "Офлайн") (confidence ?c2))
(fact (name "3D") (confidence ?c3))
(fact (name "Головоломка") (confidence ?c4))
(not (exists (fact (name "Stanley Parable"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3 ?c4))
(bind ?newConf (* ?minConf ?*confidence-rule70*))
(assert (fact (name "Stanley Parable") (confidence ?newConf)))
(assert (sendmessage "Сюжетная, Офлайн, 3D, Головоломка -> Stanley Parable" ?newConf)))
(defrule rule72
(fact (name "Классовый шутер") (confidence ?c1))
(fact (name "3D") (confidence ?c2))
(fact (name "Онлайн") (confidence ?c3))
(fact (name "Классика") (confidence ?c4))
(not (exists (fact (name "Team Fortress 2"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3 ?c4))
(bind ?newConf (* ?minConf ?*confidence-rule72*))
(assert (fact (name "Team Fortress 2") (confidence ?newConf)))
(assert (sendmessage "Классовый шутер, 3D, Онлайн, Классика -> Team Fortress 2" ?newConf)))
(defrule rule74
(fact (name "Классовый шутер") (confidence ?c1))
(fact (name "3D") (confidence ?c2))
(fact (name "Онлайн") (confidence ?c3))
(fact (name "Плохая") (confidence ?c4))
(not (exists (fact (name "Overwatch"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3 ?c4))
(bind ?newConf (* ?minConf ?*confidence-rule74*))
(assert (fact (name "Overwatch") (confidence ?newConf)))
(assert (sendmessage "Классовый шутер, 3D, Онлайн, Плохая -> Overwatch" ?newConf)))
(defrule rule76
(fact (name "Шутер") (confidence ?c1))
(fact (name "3D") (confidence ?c2))
(fact (name "Онлайн") (confidence ?c3))
(fact (name "Соревновательный") (confidence ?c4))
(not (exists (fact (name "Counter Strike"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3 ?c4))
(bind ?newConf (* ?minConf ?*confidence-rule76*))
(assert (fact (name "Counter Strike") (confidence ?newConf)))
(assert (sendmessage "Шутер, 3D, Онлайн, Соревновательный -> Counter Strike" ?newConf)))
(defrule rule78
(fact (name "Counter Strike") (confidence ?c1))
(fact (name "Старая") (confidence ?c2))
(not (exists (fact (name "Counter Strike 1.6"))))
=>
(bind ?minConf (min ?c1 ?c2))
(bind ?newConf (* ?minConf ?*confidence-rule78*))
(assert (fact (name "Counter Strike 1.6") (confidence ?newConf)))
(assert (sendmessage "Counter Strike, Старая -> Counter Strike 1.6" ?newConf)))
(defrule rule80
(fact (name "Counter Strike") (confidence ?c1))
(fact (name "Новая") (confidence ?c2))
(not (exists (fact (name "Counter Strike 2"))))
=>
(bind ?minConf (min ?c1 ?c2))
(bind ?newConf (* ?minConf ?*confidence-rule80*))
(assert (fact (name "Counter Strike 2") (confidence ?newConf)))
(assert (sendmessage "Counter Strike, Новая -> Counter Strike 2" ?newConf)))
(defrule rule82
(fact (name "RPG") (confidence ?c1))
(fact (name "Казуальная") (confidence ?c2))
(fact (name "Вид сверху") (confidence ?c3))
(fact (name "Инди") (confidence ?c4))
(not (exists (fact (name "Stardew Valley"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3 ?c4))
(bind ?newConf (* ?minConf ?*confidence-rule82*))
(assert (fact (name "Stardew Valley") (confidence ?newConf)))
(assert (sendmessage "RPG, Казуальная, Вид сверху, Инди -> Stardew Valley" ?newConf)))
(defrule rule84
(fact (name "Песочница") (confidence ?c1))
(fact (name "3D") (confidence ?c2))
(fact (name "Управление ресурсами") (confidence ?c3))
(not (exists (fact (name "Minecraft"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule84*))
(assert (fact (name "Minecraft") (confidence ?newConf)))
(assert (sendmessage "Песочница, 3D, Управление ресурсами -> Minecraft" ?newConf)))
(defrule rule86
(fact (name "Песочница") (confidence ?c1))
(fact (name "2D") (confidence ?c2))
(fact (name "RPG") (confidence ?c3))
(fact (name "Управление ресурсами") (confidence ?c4))
(not (exists (fact (name "Terraria"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3 ?c4))
(bind ?newConf (* ?minConf ?*confidence-rule86*))
(assert (fact (name "Terraria") (confidence ?newConf)))
(assert (sendmessage "Песочница, 2D, RPG, Управление ресурсами -> Terraria" ?newConf)))
(defrule rule88
(fact (name "Платформер") (confidence ?c1))
(fact (name "Вид сбоку") (confidence ?c2))
(fact (name "Сложная") (confidence ?c3))
(fact (name "Офлайн") (confidence ?c4))
(not (exists (fact (name "Cuphead"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3 ?c4))
(bind ?newConf (* ?minConf ?*confidence-rule88*))
(assert (fact (name "Cuphead") (confidence ?newConf)))
(assert (sendmessage "Платформер, Вид сбоку, Сложная, Офлайн -> Cuphead" ?newConf)))
(defrule rule90
(fact (name "Выживание") (confidence ?c1))
(fact (name "3D") (confidence ?c2))
(fact (name "Управление ресурсами") (confidence ?c3))
(not (exists (fact (name "The Long Dark"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule90*))
(assert (fact (name "The Long Dark") (confidence ?newConf)))
(assert (sendmessage "Выживание, 3D, Управление ресурсами -> The Long Dark" ?newConf)))
(defrule rule92
(fact (name "Классика") (confidence ?c1))
(fact (name "Вид сбоку") (confidence ?c2))
(fact (name "Ритм-игра") (confidence ?c3))
(fact (name "Сложная") (confidence ?c4))
(not (exists (fact (name "Chronoheart"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3 ?c4))
(bind ?newConf (* ?minConf ?*confidence-rule92*))
(assert (fact (name "Chronoheart") (confidence ?newConf)))
(assert (sendmessage "Классика, Вид сбоку, Ритм-игра, Сложная -> Chronoheart" ?newConf)))
(defrule rule94
(fact (name "Стратегия") (confidence ?c1))
(fact (name "Пошаговая") (confidence ?c2))
(fact (name "Исторический") (confidence ?c3))
(not (exists (fact (name "Civilization"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule94*))
(assert (fact (name "Civilization") (confidence ?newConf)))
(assert (sendmessage "Стратегия, Пошаговая, Исторический -> Civilization" ?newConf)))
(defrule rule96
(fact (name "Стратегия") (confidence ?c1))
(fact (name "В реальном времени") (confidence ?c2))
(fact (name "Исторический") (confidence ?c3))
(not (exists (fact (name "Hearts of Iron"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule96*))
(assert (fact (name "Hearts of Iron") (confidence ?newConf)))
(assert (sendmessage "Стратегия, В реальном времени, Исторический -> Hearts of Iron" ?newConf)))
(defrule rule98
(fact (name "Стратегия") (confidence ?c1))
(fact (name "Пошаговая") (confidence ?c2))
(fact (name "Фантастика") (confidence ?c3))
(not (exists (fact (name "XCOM"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule98*))
(assert (fact (name "XCOM") (confidence ?newConf)))
(assert (sendmessage "Стратегия, Пошаговая, Фантастика -> XCOM" ?newConf)))
(defrule rule100
(fact (name "Стратегия") (confidence ?c1))
(fact (name "Классика") (confidence ?c2))
(fact (name "Старая") (confidence ?c3))
(not (exists (fact (name "Heroes of Might and Magic"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule100*))
(assert (fact (name "Heroes of Might and Magic") (confidence ?newConf)))
(assert (sendmessage "Стратегия, Классика, Старая -> Heroes of Might and Magic" ?newConf)))
(defrule rule102
(fact (name "Стратегия") (confidence ?c1))
(fact (name "Соревновательный") (confidence ?c2))
(fact (name "В реальном времени") (confidence ?c3))
(not (exists (fact (name "Starcraft"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule102*))
(assert (fact (name "Starcraft") (confidence ?newConf)))
(assert (sendmessage "Стратегия, Соревновательный, В реальном времени -> Starcraft" ?newConf)))
(defrule rule104
(fact (name "3D") (confidence ?c1))
(fact (name "RPG") (confidence ?c2))
(fact (name "Фэнтези") (confidence ?c3))
(fact (name "Сюжетная") (confidence ?c4))
(fact (name "Офлайн") (confidence ?c5))
(not (exists (fact (name "Skyrim"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3 ?c4 ?c5))
(bind ?newConf (* ?minConf ?*confidence-rule104*))
(assert (fact (name "Skyrim") (confidence ?newConf)))
(assert (sendmessage "3D, RPG, Фэнтези, Сюжетная, Офлайн -> Skyrim" ?newConf)))
(defrule rule106
(fact (name "Управление ресурсами") (confidence ?c1))
(fact (name "Вид сверху") (confidence ?c2))
(fact (name "Сложная") (confidence ?c3))
(fact (name "Фантастика") (confidence ?c4))
(not (exists (fact (name "Factorio"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3 ?c4))
(bind ?newConf (* ?minConf ?*confidence-rule106*))
(assert (fact (name "Factorio") (confidence ?newConf)))
(assert (sendmessage "Управление ресурсами, Вид сверху, Сложная, Фантастика -> Factorio" ?newConf)))
(defrule rule108
(fact (name "Ритм-игра") (confidence ?c1))
(fact (name "Сложная") (confidence ?c2))
(fact (name "Бесплатная") (confidence ?c3))
(not (exists (fact (name "OSU"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule108*))
(assert (fact (name "OSU") (confidence ?newConf)))
(assert (sendmessage "Ритм-игра, Сложная, Бесплатная -> OSU" ?newConf)))
(defrule rule110
(fact (name "Экшен-RPG") (confidence ?c1))
(fact (name "3D") (confidence ?c2))
(fact (name "Сюжетная") (confidence ?c3))
(not (exists (fact (name "Ghost of Tsushima"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule110*))
(assert (fact (name "Ghost of Tsushima") (confidence ?newConf)))
(assert (sendmessage "Экшен-RPG, 3D, Сюжетная -> Ghost of Tsushima" ?newConf)))
(defrule rule112
(fact (name "Рогалик") (confidence ?c1))
(fact (name "Вид сбоку") (confidence ?c2))
(fact (name "Сложная") (confidence ?c3))
(not (exists (fact (name "Darkest Dungeon"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule112*))
(assert (fact (name "Darkest Dungeon") (confidence ?newConf)))
(assert (sendmessage "Рогалик, Вид сбоку, Сложная -> Darkest Dungeon" ?newConf)))
(defrule rule114
(fact (name "Затягивающая") (confidence ?c1))
(fact (name "Бесплатные дополнения") (confidence ?c2))
(not (exists (fact (name "Fortnite"))))
=>
(bind ?minConf (min ?c1 ?c2))
(bind ?newConf (* ?minConf ?*confidence-rule114*))
(assert (fact (name "Fortnite") (confidence ?newConf)))
(assert (sendmessage "Затягивающая, Бесплатные дополнения -> Fortnite" ?newConf)))
(defrule rule116
(fact (name "Фэнтези") (confidence ?c1))
(fact (name "Пошаговая") (confidence ?c2))
(fact (name "RPG") (confidence ?c3))
(not (exists (fact (name "Baldur's Gate 3"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule116*))
(assert (fact (name "Baldur's Gate 3") (confidence ?newConf)))
(assert (sendmessage "Фэнтези, Пошаговая, RPG -> Baldur's Gate 3" ?newConf)))
(defrule rule118
(fact (name "MOBA") (confidence ?c1))
(fact (name "Онлайн") (confidence ?c2))
(fact (name "Соревновательный") (confidence ?c3))
(not (exists (fact (name "League of Legends"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule118*))
(assert (fact (name "League of Legends") (confidence ?newConf)))
(assert (sendmessage "MOBA, Онлайн, Соревновательный -> League of Legends" ?newConf)))
(defrule rule120
(fact (name "Стратегия") (confidence ?c1))
(fact (name "Фэнтези") (confidence ?c2))
(fact (name "Пошаговая") (confidence ?c3))
(not (exists (fact (name "Heroes of Might and Magic"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule120*))
(assert (fact (name "Heroes of Might and Magic") (confidence ?newConf)))
(assert (sendmessage "Стратегия, Фэнтези, Пошаговая -> Heroes of Might and Magic" ?newConf)))
(defrule rule122
(fact (name "Одиночная игра") (confidence ?c1))
(fact (name "Фэнтези") (confidence ?c2))
(fact (name "RPG") (confidence ?c3))
(not (exists (fact (name "The Witcher 3"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule122*))
(assert (fact (name "The Witcher 3") (confidence ?newConf)))
(assert (sendmessage "Одиночная игра, Фэнтези, RPG -> The Witcher 3" ?newConf)))
(defrule rule124
(fact (name "Симулятор") (confidence ?c1))
(fact (name "Затягивающая") (confidence ?c2))
(fact (name "Постройка базы") (confidence ?c3))
(not (exists (fact (name "The Sims 4"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule124*))
(assert (fact (name "The Sims 4") (confidence ?newConf)))
(assert (sendmessage "Симулятор, Затягивающая, Постройка базы -> The Sims 4" ?newConf)))
(defrule rule126
(fact (name "Экшен-RPG") (confidence ?c1))
(fact (name "Реалистичная графика") (confidence ?c2))
(fact (name "3D") (confidence ?c3))
(not (exists (fact (name "Cyberpunk 2077"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule126*))
(assert (fact (name "Cyberpunk 2077") (confidence ?newConf)))
(assert (sendmessage "Экшен-RPG, Реалистичная графика, 3D -> Cyberpunk 2077" ?newConf)))
(defrule rule128
(fact (name "Крафт") (confidence ?c1))
(fact (name "Постройка базы") (confidence ?c2))
(fact (name "Затягивающая") (confidence ?c3))
(not (exists (fact (name "Minecraft"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule128*))
(assert (fact (name "Minecraft") (confidence ?newConf)))
(assert (sendmessage "Крафт, Постройка базы, Затягивающая -> Minecraft" ?newConf)))
(defrule rule130
(fact (name "Постройка базы") (confidence ?c1))
(fact (name "Симулятор") (confidence ?c2))
(fact (name "Онлайн") (confidence ?c3))
(not (exists (fact (name "Fallout Shelter"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule130*))
(assert (fact (name "Fallout Shelter") (confidence ?newConf)))
(assert (sendmessage "Постройка базы, Симулятор, Онлайн -> Fallout Shelter" ?newConf)))
(defrule rule132
(fact (name "MOBA") (confidence ?c1))
(fact (name "Реалистичная графика") (confidence ?c2))
(fact (name "Соревновательный") (confidence ?c3))
(not (exists (fact (name "Apex Legends"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule132*))
(assert (fact (name "Apex Legends") (confidence ?newConf)))
(assert (sendmessage "MOBA, Реалистичная графика, Соревновательный -> Apex Legends" ?newConf)))
(defrule rule134
(fact (name "Сложная") (confidence ?c1))
(fact (name "Сложная") (confidence ?c2))
(fact (name "Платформер") (confidence ?c3))
(fact (name "Офлайн") (confidence ?c4))
(not (exists (fact (name "Hollow Knight"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3 ?c4))
(bind ?newConf (* ?minConf ?*confidence-rule134*))
(assert (fact (name "Hollow Knight") (confidence ?newConf)))
(assert (sendmessage "Сложная, Сложная, Платформер, Офлайн -> Hollow Knight" ?newConf)))
(defrule rule136
(fact (name "3D") (confidence ?c1))
(fact (name "Вид от 3-го лица") (confidence ?c2))
(fact (name "Сложная") (confidence ?c3))
(not (exists (fact (name "Dark Souls"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule136*))
(assert (fact (name "Dark Souls") (confidence ?newConf)))
(assert (sendmessage "3D, Вид от 3-го лица, Сложная -> Dark Souls" ?newConf)))
(defrule rule138
(fact (name "Онлайн") (confidence ?c1))
(fact (name "Детективная") (confidence ?c2))
(fact (name "Вид сверху") (confidence ?c3))
(not (exists (fact (name "Among Us"))))
=>
(bind ?minConf (min ?c1 ?c2 ?c3))
(bind ?newConf (* ?minConf ?*confidence-rule138*))
(assert (fact (name "Among Us") (confidence ?newConf)))
(assert (sendmessage "Онлайн, Детективная, Вид сверху -> Among Us" ?newConf)))