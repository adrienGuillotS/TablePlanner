# Plan de table pour mamoune


## 📋 Prérequis

### Back-end (Python Flask)
- **Python** : Version 3.7 ou supérieure

### Front-end (Flutter)
- **Flutter** : Version 3.0 ou supérieure

---

## 🚀 Installation

### Cloner le projet
```bash
git clone https://github.com/adrienGuillotS/PlanDeTable.git
cd PlanDeTable
```

### Back-end : Installation des dépendances
1. Rendez-vous dans le dossier `back` :
   ```bash
   cd back
   ```

2. Créez un environnement virtuel :
   ```bash
   python -m venv venv
   source venv/bin/activate  # Sur macOS/Linux
   venv\Scripts\activate     # Sur Windows
   ```

3. Installez les dépendances :
   ```bash
   pip install -r requirements.txt
   ```


### Front-end : Préparation de Flutter
1. Rendez-vous dans le dossier `front` :
   ```bash
   cd ../front
   ```

2. Installez les dépendances Flutter :
   ```bash
   flutter pub get
   ```

---

## 🖥️ Lancement de l'application

### Démarrer le Back-end
1. Assurez-vous d'être dans le dossier `back` et que l'environnement virtuel est activé :
   ```bash
   cd back
   source venv/bin/activate  # macOS/Linux
   venv\Scripts\activate     # Windows
   ```

2. Lancez le serveur Flask :
   ```bash
   flask run --host=0.0.0.0 --port=5000
   ```

Par défaut, le serveur Flask sera disponible sur **`http://127.0.0.1:5000`**.

---

### Démarrer le Front-end
1. Rendez-vous dans le dossier `front` :
   ```bash
   cd ../front
   ```

2. Lancez l'application Flutter :
   ```bash
   flutter run
   ```
---

## 📝 Auteur
- **Adrien et Oscar** 

