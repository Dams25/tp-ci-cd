// ==============================================================================
// SCRIPT D'INITIALISATION MONGODB - TO-DO LIST PRODUCTION
// ==============================================================================

// Connexion à la base de données
db = db.getSiblingDB('todolist');

// Création de l'utilisateur application avec permissions limitées
db.createUser({
  user: 'todoapp',
  pwd: 'todoapp_secure_password',
  roles: [
    {
      role: 'readWrite',
      db: 'todolist'
    }
  ]
});

// Création des collections avec validation
db.createCollection('users', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['email', 'password', 'createdAt'],
      properties: {
        email: {
          bsonType: 'string',
          pattern: '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
          description: 'Email must be a valid email address'
        },
        password: {
          bsonType: 'string',
          minLength: 6,
          description: 'Password must be at least 6 characters'
        },
        name: {
          bsonType: 'string',
          description: 'User name'
        },
        createdAt: {
          bsonType: 'date',
          description: 'User creation date'
        }
      }
    }
  }
});

db.createCollection('tasks', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['title', 'userId', 'createdAt'],
      properties: {
        title: {
          bsonType: 'string',
          minLength: 1,
          maxLength: 200,
          description: 'Task title is required and must be between 1-200 characters'
        },
        description: {
          bsonType: 'string',
          maxLength: 1000,
          description: 'Task description max 1000 characters'
        },
        completed: {
          bsonType: 'bool',
          description: 'Task completion status'
        },
        userId: {
          bsonType: 'objectId',
          description: 'Reference to user who owns this task'
        },
        createdAt: {
          bsonType: 'date',
          description: 'Task creation date'
        },
        completedAt: {
          bsonType: 'date',
          description: 'Task completion date'
        }
      }
    }
  }
});

// Index pour optimiser les performances
db.users.createIndex({ email: 1 }, { unique: true });
db.tasks.createIndex({ userId: 1 });
db.tasks.createIndex({ completed: 1 });
db.tasks.createIndex({ createdAt: -1 });

// Données de test pour la production (optionnel - à supprimer si non désiré)
print('✅ MongoDB initialization completed for TO-DO List production');
print('📊 Collections created: users, tasks');
print('🔐 User created: todoapp (readWrite permissions)');
print('⚡ Indexes created for performance optimization');
