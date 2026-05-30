<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>منصة مسابقات دراسة الكتاب المقدس | أبي سيفين</title>
    <style>
        /* الهوية البصرية الأرثوذكسية العريقة */
        :root {
            --coptic-maroon: #580F0F; 
            --coptic-gold: #C5A059;   
            --coptic-dark: #220505;
            --bg-cream: #FAF8F5;       
            --white: #FFFFFF;
            --success: #1b5e20;
            --error: #b71c1c;
            --text-dark: #3E2723;
        }

        * {
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--bg-cream);
            color: var(--text-dark);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            background-image: radial-gradient(rgba(197, 160, 89, 0.05) 1px, transparent 0);
            background-size: 24px 24px;
        }

        header {
            background: linear-gradient(135deg, var(--coptic-dark), var(--coptic-maroon));
            color: var(--white);
            text-align: center;
            padding: 25px 15px;
            border-bottom: 6px double var(--coptic-gold);
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
        }

        header h1 { font-size: 24px; font-weight: 700; margin-bottom: 5px; letter-spacing: 0.5px; }
        header h2 { font-size: 16px; color: var(--coptic-gold); font-weight: 400; }
        .cross-icon { font-size: 20px; color: var(--coptic-gold); margin: 5px 0; }

        .container {
            max-width: 650px;
            width: 92%;
            margin: 25px auto;
            background: var(--white);
            padding: 30px;
            border-radius: 16px;
            border: 1px solid rgba(197, 160, 89, 0.2);
            box-shadow: 0 10px 35px rgba(88, 15, 15, 0.05);
            animation: formSlide 0.4s ease-out;
        }

        @keyframes formSlide {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .page { display: none; }
        .active { display: block; }

        /* تنسيق إطار الصور الأرثوذكسية المعدل */
        .images-row {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        .saint-img {
            width: 130px;
            height: 170px;
            object-fit: cover;
            border-radius: 12px;
            border: 3px solid var(--coptic-gold);
            box-shadow: 0 5px 15px rgba(0,0,0,0.15);
        }

        h3 { color: var(--coptic-maroon); text-align: center; font-size: 20px; margin-bottom: 20px; font-weight: 600; }

        select {
            width: 100%; padding: 14px; margin-bottom: 25px;
            border: 2px solid #E0DCD5; border-radius: 10px; font-size: 16px;
            background-color: #FCFBF9; color: var(--text-dark); text-align: center;
            outline: none; cursor: pointer;
        }
        select:focus { border-color: var(--coptic-gold); box-shadow: 0 0 8px rgba(197, 160, 89, 0.2); }

        button {
            width: 100%; background: linear-gradient(135deg, var(--coptic-maroon), #7A1717);
            color: var(--white); border: none; padding: 14px; font-size: 18px;
            font-weight: bold; border-radius: 10px; cursor: pointer; transition: all 0.3s;
            box-shadow: 0 4px 10px rgba(88, 15, 15, 0.15);
        }
        button:hover {
            background: linear-gradient(135deg, #7A1717, var(--coptic-maroon));
            color: var(--coptic-gold); transform: translateY(-1px);
        }

        /* شريط التوقيت والتقدم */
        .quiz-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; font-weight: 600; font-size: 14px; }
        .timer-box { background: #FFF3E0; color: #E65100; padding: 6px 14px; border-radius: 20px; border: 1px solid #FFE0B2; }
        .progress-container { width: 100%; height: 6px; background: #EFEBE9; border-radius: 4px; margin-bottom: 25px; overflow: hidden; }
        .progress-bar { height: 100%; width: 0%; background: var(--coptic-gold); transition: width 0.4s ease; }

        /* الأسئلة والاختيارات */
        .question-text { font-size: 18px; font-weight: 600; margin-bottom: 20px; text-align: center; line-height: 1.5; }
        .option-card { background: #FDFDFD; border: 2px solid #ECE9E4; padding: 14px; margin-bottom: 12px; border-radius: 10px; cursor: pointer; font-size: 16px; transition: all 0.2s ease; }
        .option-card:hover { border-color: var(--coptic-gold); background: #FAF6EE; }
        .option-card.correct { background-color: #E8F5E9 !important; border-color: var(--success) !important; color: var(--success); font-weight: bold; }
        .option-card.wrong { background-color: #FFEBEE !important; border-color: var(--error) !important; color: var(--error); }
        .disabled { pointer-events: none; }

        /* مراجعة الإجابات */
        .review-title { margin-top: 25px; border-top: 2px dashed #E0DCD5; padding-top: 20px; color: var(--coptic-maroon); }
        .review-item { background: #FAF9F6; padding: 15px; border-radius: 8px; margin-bottom: 15px; border-right: 4px solid var(--coptic-gold); text-align: right; }
        .review-q { font-weight: bold; margin-bottom: 5px; }
        .review-ans { font-size: 14px; margin-bottom: 3px; }
        
        /* جدول لوحة الإدارة */
        table { width: 100%; border-collapse: collapse; margin-top: 15px; font-size: 14px; }
        th, td { padding: 10px; text-align: center; border-bottom: 1px solid #ddd; }
        th { background-color: var(--coptic-maroon); color: white; }
        .admin-btn { padding: 6px 10px; font-size: 12px; background: #555; width: auto; display: inline-block; margin: 2px; border: none; color: white; border-radius: 5px;}
    </style>
</head>
<body>

    <header>
        <h1>كنيسة الشهيد العظيم فيلوباتير مرقوريوس أبي سيفين - بمدينة عامر</h1>
        <h2>اجتماع الخدام | منصة مسابقات دراسة الكتاب المقدس اليومية</h2>
        <div class="cross-icon">✙ ✙ ✙</div>
    </header>

    <div class="container">

        <div id="loginPage" class="page active">
            <div class="images-row">
                <img src="image_0.png" alt="القديس مرقوريوس أبي سيفين" class="saint-img">
                <img src="image_1.png" alt="السيدة العذراء والطفل يسوع" class="saint-img">
            </div>
            <h3>باسم الآب والابن والروح القدس الإله الواحد.. آمين</h3>
            <p style="text-align: center; margin-bottom: 15px; font-size: 14px; color:#777;">من فضلك اختر اسمك من القائمة أدناه لبدء المسابقة اليومية (10 أسئلة):</p>
            
            <select id="servantSelect">
                <option value="">-- اختر اسمك يا خادم من هنا --</option>
                <option value="عادل فرج">عادل فرج</option>
                <option value="عماد سمير">عماد سمير</option>
                <option value="ماريانا ادورد">ماريانا ادورد</option>
                <option value="سمرجادالرب">سمرجادالرب</option>
                <option value="جيهان شحاتة">جيهان شحاتة</option>
                <option value="مارينا اشرف">مارينا اشرف</option>
                <option value="مينا اشرف">مينا اشرف</option>
                <option value="كيرلس اسامة">كيرلس اسامة</option>
                <option value="سماح نعيم">سماح نعيم</option>
                <option value="ماركو مجدي">ماركو مجدي</option>
                <option value="مينا مجدي">مينا مجدي</option>
                <option value="ميرنا عماد">ميرنا عماد</option>
                <option value="شيري شهدي">شيري شهدي</option>
                <option value="امير رامز">امير رامز</option>
                <option value="فادي كحيل">فادي كحيل</option>
                <option value="كيرلس فادي">كيرلس فادي</option>
                <option value="مريان عادل">مريان عادل</option>
            </select>
            
            <button onclick="attemptLogin()">ابدأ المسابقة اليومية</button>
            
            <p style="text-align: center; margin-top: 40px;">
                <span onclick="openAdminPanel()" style="font-size: 12px; color: #bbb; cursor: pointer;">⚙️ لوحة التحكم السرية للأمانة</span>
            </p>
        </div>

        <div id="quizPage" class="page">
            <div class="quiz-header">
                <span id="questionCounter">السؤال 1 من 10</span>
                <span class="timer-box">الوقت المتبقي للسؤال: <span id="timeLeft">02:00</span></span>
            </div>
            <div class="progress-container">
                <div id="progressBar" class="progress-bar"></div>
            </div>
            
            <div id="quizContent">
                <div id="questionText" class="question-text">جاري تحميل السؤال الكنسي...</div>
                <div id="optionsContainer"></div>
            </div>
        </div>

        <div id="resultPage" class="page">
            <h3>✙ نشكر الله ✙</h3>
            <div id="servantFinalReport" style="text-align: center; font-size: 18px; margin-bottom: 25px; line-height: 1.6;"></div>
            
            <button onclick="toggleReview()" id="reviewBtn">اضغط هنا لمعرفة إجاباتك الشخصية ومراجعتها</button>
            
            <div id="reviewSection" style="display: none;">
                <h3 class="review-title">مراجعة إجاباتك الشخصية:</h3>
                <div id="reviewContainer"></div>
            </div>
            
            <button onclick="goToHome()" style="margin-top: 20px; background: #666;">العودة للرئيسية</button>
        </div>

        <div id="adminPage" class="page">
            <h3>⚙️ لوحة تحكم أمانة الاجتماع</h3>
            <p style="text-align: center; font-size: 13px; margin-bottom: 15px; color: var(--success)">يمكنك تعديل درجات الخدام أو إلغاء حظرهم لو حدث خطأ في إحدى الإجابات.</p>
            
            <table>
                <thead>
                    <tr>
                        <th>الخادم</th>
                        <th>الدرجة</th>
                        <th>التحكم والتعديل</th>
                    </tr>
                </thead>
                <tbody id="adminTableBody">
                    </tbody>
            </table>
            
            <button onclick="goToHome()" style="margin-top: 25px; background: var(--coptic-dark);">الخروج والعودة لصفحة الدخول</button>
        </div>

    </div>

    <script>
        // بنك الأسئلة الـ 10 (دقيقتين لكل سؤال)
        const quizQuestions = [
            { question: "السؤال 1: كم عدد المجامع المسكونية المعترف بها في كنيستنا الأرثوذكسية؟", options: ["3 مجامع", "4 مجامع", "7 مجامع", "2 مجمع"], answer: "3 مجامع" },
            { question: "السؤال 2: من هو النبي الذي لُقب بالرائي وكتب سفر المراثي؟", options: ["إشعياء", "إرميا", "حزقيال", "دانيال"], answer: "إرميا" },
            { question: "السؤال 3: في أي سفر نجد قصة صعود إيليا النبي في العاصفة؟", options: ["ملوك الأول", "ملوك الثاني", "أخبار الأيام الأول", "صموئيل الثاني"], answer: "ملوك الثاني" },
            { question: "السؤال 4: ما هو اسم السفر الذي يأتي مباشرة بعد سفر يشوع؟", options: ["راعوث", "القضاة", "صموئيل الأول", "عزرا"], answer: "القضاة" },
            { question: "السؤال 5: من هو الرسول الذي كرز في أرض مصر وأسس الكنيسة القبطية؟", options: ["مارمرقس الرسول", "مارمينا", "أندراوس الرسول", "توما الرسول"], answer: "مارمرقس الرسول" },
            { question: "السؤال 6: كم مكث يونان النبي في بطن الحوت؟", options: ["يومين وليلتين", "3 أيام و3 ليالٍ", "7 أيام", "أربعين يوماً"], answer: "3 أيام و3 ليالٍ" },
            { question: "السؤال 7: ما هو آخر أسفار العهد القديم في الترتيب؟", options: ["ملاخي", "حجي", "زكريا", "دانيال"], answer: "ملاخي" },
            { question: "السؤال 8: أي من هذه الأسفار يعتبر من الأسفار الشعرية؟", options: ["الجامعة", "تكوين", "أعمال الرسل", "رؤيا"], answer: "الجامعة" },
            { question: "السؤال 9: من هو الملك الذي بنى الهيكل الأول في أورشليم؟", options: ["داود الملك", "سليمان الحكيم", "شاول الملك", "حزقيا الملك"], answer: "سليمان الحكيم" },
            { question: "السؤال 10: من هي المرأة التي خلصت شعبها من الهلاك ومكتوب سفر باسمها？", options: ["راعوث", "أستير", "ديبورة", "يهوديت"], answer: "أستير" }
        ];

        let selectedServant = "";
        let currentQuestionIndex = 0;
        let score = 0;
        let timerInterval;
        let timeLeft = 120; 
        let userAnswersLog = [];

        // معرف فريد للمسابقة اليومية لمنع التكرار (يتغير كل يوم لفتح مسابقة جديدة)
        const DAILY_QUIZ_ID = "quiz_day_30_05_2026"; 
        const ADMIN_PASSWORD = "1234"; // الرقم السري الافتراضي للوحة التحكم للأمانة

        // إدارة الدخول الشخصي المحمي
        function attemptLogin() {
            selectedServant = document.getElementById("servantSelect").value;
            if (!selectedServant) {
                alert("برجاء اختيار اسمك أولاً يا خادم ليتم فتح المسابقة اليومية.");
                return;
            }

            // فحص كشف نتائج المتصفح الشخصي لليوم
            let scoresData = JSON.parse(localStorage.getItem(DAILY_QUIZ_ID + "_scores")) || {};
            if (scoresData[selectedServant] !== undefined) {
                alert(`عذراً يا ${selectedServant}، لقد قمت بالاشتراك وحل مسابقة اليوم بالفعل! لا يُسمح بالتكرار.`);
                return;
            }

            // إذا كان الاسم متاح، نبدأ المسابقة
            switchPage("quizPage");
            startQuiz();
        }

        // تشغيل المسابقة وتوقيت الدقيقتين لكل سؤال
        function startQuiz() {
            currentQuestionIndex = 0;
            score = 0;
            userAnswersLog = [];
            showQuestion();
        }

        function showQuestion() {
            clearInterval(timerInterval);
            timeLeft = 120; // 120 ثانية = دقيقتان لكل سؤال
            updateTimerDisplay();

            if (currentQuestionIndex < quizQuestions.length) {
                // تحديث العداد وشريط التقدم الذهبي
                document.getElementById("questionCounter").innerText = `السؤال ${currentQuestionIndex + 1} من ${quizQuestions.length}`;
                let progressPercent = (currentQuestionIndex / quizQuestions.length) * 100;
                document.getElementById("progressBar").style.width = `${progressPercent}%`;

                let currentQ = quizQuestions[currentQuestionIndex];
                document.getElementById("questionText").innerText = currentQ.question;

                let optionsHtml = "";
                currentQ.options.forEach(opt => {
                    optionsHtml += `<div class="option-card" onclick="selectOption(this, '${opt}')">${opt}</div>`;
                });
                document.getElementById("optionsContainer").innerHTML = optionsHtml;

                // تشغيل تايمر الدقيقتين
                timerInterval = setInterval(() => {
                    timeLeft--;
                    updateTimerDisplay();
                    if (timeLeft <= 0) {
                        clearInterval(timerInterval);
                        handleTimeout();
                    }
                }, 1000);

            } else {
                finishQuiz();
            }
        }

        function updateTimerDisplay() {
            let minutes = Math.floor(timeLeft / 60);
            let seconds = timeLeft % 60;
            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;
            document.getElementById("timeLeft").innerText = `${minutes}:${seconds}`;
        }

        function handleTimeout() {
            alert("انتهى وقت السؤال الحالي المخصص (دقيقتان)! سننتقل للسؤال التالي.");
            userAnswersLog.push({ question: quizQuestions[currentQuestionIndex].question, userAns: "لم يتم الحل (انتهى الوقت)", correctAns: quizQuestions[currentQuestionIndex].answer, isCorrect: false });
            currentQuestionIndex++;
            showQuestion();
        }

        // التصحيح الفوري المحمي لكل سؤال
        function selectOption(element, selectedOpt) {
            clearInterval(timerInterval); // إيقاف التايمر فور الاختيار
            document.querySelectorAll('.option-card').forEach(card => card.classList.add('disabled'));

            let currentQ = quizQuestions[currentQuestionIndex];
            let isCorrect = (selectedOpt === currentQ.answer);

            if (isCorrect) {
                element.classList.add('correct');
                score++;
            } else {
                element.classList.add('wrong');
                document.querySelectorAll('.option-card').forEach(card => {
                    if (card.innerText === currentQ.answer) card.classList.add('correct');
                });
            }

            // تسجيل الإجابة للمراجعة الشخصية النهائية
            userAnswersLog.push({ question: currentQ.question, userAns: selectedOpt, correctAns: currentQ.answer, isCorrect: isCorrect });

            setTimeout(() => {
                currentQuestionIndex++;
                showQuestion();
            }, 1200); // انتظار ثانية ونصف قبل الانتقال
        }

        // إنهاء المسابقة وتجميد الحساب لليوم
        function finishQuiz() {
            document.getElementById("progressBar").style.width = `100%`;
            switchPage("resultPage");

            let percentage = Math.round((score / quizQuestions.length) * 100);
            document.getElementById("servantFinalReport").innerHTML = `الخادم العزيز: <strong style="color:var(--coptic-maroon)">${selectedServant}</strong><br>
            لقد أتممت مسابقة دراسة الكتاب المقدس اليوم بنجاح.<br>
            <span style="font-size:22px; font-weight:bold; color:var(--success);">درجتك هي: ${score} من ${quizQuestions.length} (${percentage}%)</span>`;

            // حفظ النتيجة النهائية في المتصفح لليوم
            let scoresData = JSON.parse(localStorage.getItem(DAILY_QUIZ_ID + "_scores")) || {};
            scoresData[selectedServant] = score;
            localStorage.setItem(DAILY_QUIZ_ID + "_scores", JSON.stringify(scoresData));

            buildReviewSection();
        }

        function buildReviewSection() {
            let reviewHtml = "";
            userAnswersLog.forEach(item => {
                let statusColor = item.isCorrect ? "var(--success)" : "var(--error)";
                reviewHtml += `
                    <div class="review-item">
                        <div class="review-q">${item.question}</div>
                        <div class="review-ans" style="color:${statusColor}; font-weight:600;">إجابتك: ${item.userAns}</div>
                        ${!item.isCorrect ? `<div class="review-ans">الإجابة المعتمدة كنسياً: ${item.correctAns}</div>` : ''}
                    </div>
                `;
            });
            document.getElementById("reviewContainer").innerHTML = reviewHtml;
        }

        function toggleReview() {
            let section = document.getElementById("reviewSection");
            let btn = document.getElementById("reviewBtn");
            if (section.style.display === "none") {
                section.style.display = "block";
                btn.innerText = "إخفاء مراجعة الإجابات";
            } else {
                section.style.display = "none";
                btn.innerText = "اضغط هنا لمعرفة إجاباتك الشخصية ومراجعتها";
            }
        }

        // نظام لوحة التحكم والتحرير السري للأمانة
        function openAdminPanel() {
            let pw = prompt("برجاء إدخال الرقم السري لأمانة اجتماع الخدام لفتح لوحة التحكم:");
            if (pw === ADMIN_PASSWORD) {
                switchPage("adminPage");
                loadAdminData();
            } else if (pw !== null) {
                alert("الرقم السري غير صحيح! عذراً هذه المنطقة مخصصة لأمين الاجتماع فقط.");
            }
        }

        function loadAdminData() {
            let scoresData = JSON.parse(localStorage.getItem(DAILY_QUIZ_ID + "_scores")) || {};
            let html = "";
            
            // قراءة كشف نتائج المتصفح الشخصي لليوم
            if (Object.keys(scoresData).length === 0) {
                html = "<tr><td colspan='3' style='color:#888;'>لم يقم أي خادم بحل المسابقة اليوم حتى الآن.</td></tr>";
            } else {
                for (let servant in scoresData) {
                    html += `
                        <tr>
                            <td><strong>${servant}</strong></td>
                            <td style="color:var(--coptic-maroon); font-weight:bold;">${scoresData[servant]} / 10</td>
                            <td>
                                <button class="admin-btn" style="background:var(--success);" onclick="editScore('${servant}')">تعديل</button>
                                <button class="admin-btn" style="background:var(--error);" onclick="resetBlock('${servant}')">إلغاء حظر وإعادة</button>
                            </td>
                        </tr>
                    `;
                }
            }
            document.getElementById("adminTableBody").innerHTML = html;
        }

        function editScore(servantName) {
            let scoresData = JSON.parse(localStorage.getItem(DAILY_QUIZ_ID + "_scores")) || {};
            let currentScore = scoresData[servantName];
            let newScore = prompt(`الدرجة الحالية لـ (${servantName}) هي ${currentScore}.\nاكتب الدرجة الجديدة المُراد اعتمادها كنسياً (من 0 إلى 10):`, currentScore);
            
            if (newScore !== null && newScore.trim() !== "") {
                let parsed = parseInt(newScore);
                if (parsed >= 0 && parsed <= 10) {
                    scoresData[servantName] = parsed;
                    localStorage.setItem(DAILY_QUIZ_ID + "_scores", JSON.stringify(scoresData));
                    alert(`تم تعديل درجة الخادم بنجاح!`);
                    loadAdminData(); // إعادة تحديث الجدول
                } else {
                    alert("برجاء إدخال رقم صحيح من 0 لـ 10.");
                }
            }
        }

        function resetBlock(servantName) {
            if (confirm(`هل أنت متأكد من إلغاء حظر الخادم (${servantName}) لليوم؟\nهذا سيسمح له بدخول المسابقة وحلها من جديد.`)) {
                let scoresData = JSON.parse(localStorage.getItem(DAILY_QUIZ_ID + "_scores")) || {};
                delete scoresData[servantName]; // حذف بياناته تماماً لليوم
                localStorage.setItem(DAILY_QUIZ_ID + "_scores", JSON.stringify(scoresData));
                alert("تم إلغاء حظر الخادم ويمكنه الدخول الآن.");
                loadAdminData();
            }
        }

        function goToHome() {
            document.getElementById("servantSelect").value = "";
            switchPage("loginPage");
        }

        function switchPage(pageId) {
            document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
            document.getElementById(pageId).classList.add('active');
        }
    </script>
</body>
</html>
