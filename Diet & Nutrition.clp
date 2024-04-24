(defrule read-gender
    (initial-fact)
    =>
    (printout t crlf crlf "Welcome! Diet and Nutrition Expert System" crlf )
    (printout t "*****************************************" crlf)
    (printout t "This program can provide you with:" crlf)
    (printout t "1. Your Body Mass Index (BMI) and body status." crlf)
    (printout t "2. Recommended daily calories needed based on your body status." crlf)
    (printout t "3. Daily protein needed based on your weight (kgs)." crlf)
    (printout t "4. Daily calcium needed based on your age." crlf)
    (printout t "5. Daily fiber needed based on your calories needed." crlf)
    (printout t "6. Daily carbohydrates needed based on your weight (kgs)." crlf)
    (printout t "*****************************************" crlf crlf)
    (printout t "What is your gender (Female/Male) *case-sensitive*: ")
    (assert (gender (read))))

(defrule read-age
   (gender ?)
   =>
   (printout t "Please enter your age: ")
   (assert (age (read))))

(defrule read-height
   (age ?)
   =>
   (printout t "Please enter your height (in meters): ")
   (assert (height (read))))

(defrule read-weight 
   (height ?)
   =>
   (printout t "Please enter your weight (in KGs): ")
   (assert (weight (read))))

(defrule read-activity-days
    (weight ?)
    =>
    (printout t "How many days do you exercise per week: ")
    (assert (activity-days (read))))

(defrule activity-sedentary
   (activity-days ?d)
   =>
   (if (<= ?d 1) then
      (assert (activity-factor 1.2))))

(defrule activity-moderate
   (activity-days ?d)
   =>
   (if (and (>= ?d 2) (<= ?d 4)) then
      (assert (activity-factor 1.55))))

(defrule activity-hard
   (activity-days ?d)
   =>
   (if (>= ?d 5) then
      (assert (activity-factor 1.9))))

(defrule calculate-BMI
   (weight ?w)
   (height ?h)
   =>
   (assert (bmi (/ ?w (* ?h ?h)))))

(defrule status-underweight
   (bmi ?b)
   =>
   (if (< ?b 18.5) then
      (assert (body-status underweight))))

(defrule status-normal-weight
   (bmi ?b)
   =>
   (if (and (>= ?b 18.5) (<= ?b 24.9)) then
      (assert (body-status normal-weight))))

(defrule status-overweight
   (bmi ?b)
   =>
   (if (>= ?b 25) then
      (assert (body-status overweight))))

(defrule status-obesity
    (bmi ?b)
    =>
    (if (>= ?b 29.9) then
        (assert (body-status obesity))))

(defrule calculate-calories-needed-female
   (gender Female)
   (age ?a)
   (weight ?w)
   (height ?h)
   (activity-factor ?af)
   =>
   (assert (calories-needed (+ (- (- (+ (* 10 ?w) (* 6.25 ?h) (* 5 ?a)) 161) ?af)))))

(defrule calculate-calories-needed-male
   (gender Male)
   (age ?a)
   (weight ?w)
   (height ?h)
   (activity-factor ?af)
   =>
   (assert (calories-needed (+ (- (- (+ (* 10 ?w) (* 6.25 ?h) (* 5 ?a)) 5) ?af)))))

(defrule get-calcium-baby
   (age ?a)
   =>
   (if (<= ?a 1) then
      (assert (calcium-needed 400))))

(defrule get-calcium-children
   (age ?a)
   =>
   (if (and (>= ?a 2) (<= ?a 8)) then
      (assert (calcium-needed 1000))))

(defrule get-calcium-teenager 
   (age ?a)
   =>
   (if (and (>= ?a 9) (<= ?a 18)) then
      (assert (calcium-needed 1300))))

(defrule get-calcium-adult 
   (age ?a)
   =>
   (if (and (>= ?a 19) (<= ?a 50)) then
      (assert (calcium-needed 1000))))

(defrule get-calcium-oldpeople 
   (age ?a)
   =>
   (if (>= ?a 51) then
      (assert (calcium-needed 1200))))

(defrule get-protein
   (weight ?w)
   =>
   (assert (protein-needed (* ?w 0.8))))

(defrule get-carbohydrate
   (weight ?w)
   =>
   (assert (carbohydrate-needed (* ?w 3))))

(defrule get-fiber
   (calories-needed ?c)
   =>
   (assert (fiber-needed (/ ?c 10))))

(defrule protein-advice
    (protein-needed ?p)
    =>
    (printout t crlf crlf " ######### Result ######### " crlf
              " 1. You need " ?p "g of protein per day. " crlf))

(defrule carbohydrate-advice
    (carbohydrate-needed ?ca)
    =>
    (printout t " 2. You need " ?ca "g of carbohydrate per day. " crlf))

(defrule fiber-advice
    (fiber-needed ?f)
    =>
    (printout t " 3. You need " ?f "g of fiber per day. " crlf))

(defrule calcium-advice
    (calcium-needed ?c)
    =>
    (printout t " 4. You need " ?c "mg of calcium per day. " crlf))

(defrule calories-advice-underweight
   (body-status underweight)
   (calories-needed ?c)
   =>
   (printout t " 5. Your Body Mass Index (BMI) indicates you are underweight, with a required intake of " ?c " calories per day." crlf
              " 6. For advice from experts, you may need an additional 300 calories per day to gain 0.25 kg/week." crlf crlf))

(defrule calories-advice-normal-weight
    (body-status normal-weight)
    (calories-needed ?c)
    =>
    (printout t " 5. Your Body Mass Index (BMI) indicates you are of normal weight, with a required intake of " ?c " calories per day to maintain your health." crlf crlf))

(defrule calories-advice-overweight
    (body-status overweight)
    (calories-needed ?c)
    =>
    (printout t " 5. Your Body Mass Index (BMI) indicates you are overweight, with a required intake of " ?c " calories per day to maintain your health." crlf
              " 6. For advice from experts, you may need to reduce your daily calories by 300 to aid in weight loss." crlf crlf))

(defrule calories-advice-obesity
    (body-status obesity)
    (calories-needed ?c)
    =>
    (printout t " 5. Your Body Mass Index (BMI) indicates you are obese, with a required intake of " ?c " calories per day." crlf
              " 6. For advice from experts, you may need to reduce your daily calories by 500 to aid in weight loss." crlf crlf))