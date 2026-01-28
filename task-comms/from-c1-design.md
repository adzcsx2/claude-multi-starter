# C1 设计任务输出

## 📊 任务1：用户登录功能

### 需求理解
创建一个现代化的用户登录系统，要求：
- 简洁美观的登录界面
- 完整的表单验证
- 友好的错误提示
- 响应式设计（支持移动端）

### 🎨 界面设计

#### 布局方案
```
┌─────────────────────────────────────┐
│                                     │
│        ┌─────────────────┐          │
│        │                 │          │
│        │   用户登录      │          │
│        │                 │          │
│        │  ┌───────────┐  │          │
│        │  │ 用户名    │  │          │
│        │  └───────────┘  │          │
│        │                 │          │
│        │  ┌───────────┐  │          │
│        │  │ 密码      │  │          │
│        │  └───────────┘  │          │
│        │                 │          │
│        │  ☐ 记住我       │          │
│        │                 │          │
│        │  ┌───────────┐  │          │
│        │  │   登录    │  │          │
│        │  └───────────┘  │          │
│        │                 │          │
│        │  忘记密码？      │          │
│        │                 │          │
│        └─────────────────┘          │
│                                     │
└─────────────────────────────────────┘
```

### 🏗️ 技术架构

#### 文件结构
```
login.html
├── HTML 结构 (登录表单)
├── CSS 样式 (内嵌，现代化设计)
└── JavaScript 逻辑 (内嵌，表单验证)
```

#### 核心功能

1. **表单验证**
   - 用户名：3-20个字符，必填
   - 密码：6-20个字符，必填
   - 实时验证反馈

2. **登录逻辑**
   ```javascript
   function handleLogin(event) {
       event.preventDefault();

       const username = document.getElementById('username').value.trim();
       const password = document.getElementById('password').value;
       const rememberMe = document.getElementById('remember').checked;

       // 验证
       if (!validateUsername(username)) {
           showError('用户名长度必须在3-20个字符之间');
           return;
       }

       if (!validatePassword(password)) {
           showError('密码长度必须在6-20个字符之间');
           return;
       }

       // 模拟登录（实际项目中需要连接后端API）
       const loginData = {
           username,
           password,
           rememberMe,
           timestamp: new Date().toISOString()
       };

       // 模拟验证（示例）
       if (username === 'demo' && password === 'demo123') {
           showSuccess('登录成功！正在跳转...');
           // 保存登录状态
           if (rememberMe) {
               localStorage.setItem('loginUser', username);
           }
           // 延迟跳转（模拟）
           setTimeout(() => {
               // 可以跳转到主页
               alert('登录成功！欢迎 ' + username);
           }, 1000);
       } else {
           showError('用户名或密码错误（提示：demo/demo123）');
       }
   }
   ```

3. **用户体验**
   - 输入框焦点动画
   - 错误提示淡入淡出
   - 加载状态显示
   - 密码可见性切换

### 📝 详细设计文档

#### HTML 元素
```html
<div class="login-container">
    <div class="login-box">
        <h2>用户登录</h2>

        <form id="loginForm" onsubmit="handleLogin(event)">
            <!-- 用户名 -->
            <div class="input-group">
                <label for="username">用户名</label>
                <input
                    type="text"
                    id="username"
                    placeholder="请输入用户名"
                    autocomplete="username"
                    required
                >
                <span class="error-message" id="usernameError"></span>
            </div>

            <!-- 密码 -->
            <div class="input-group">
                <label for="password">密码</label>
                <div class="password-input">
                    <input
                        type="password"
                        id="password"
                        placeholder="请输入密码"
                        autocomplete="current-password"
                        required
                    >
                    <button type="button" class="toggle-password" onclick="togglePassword()">
                        👁️
                    </button>
                </div>
                <span class="error-message" id="passwordError"></span>
            </div>

            <!-- 记住我 -->
            <div class="checkbox-group">
                <input type="checkbox" id="remember" name="remember">
                <label for="remember">记住我</label>
            </div>

            <!-- 登录按钮 -->
            <button type="submit" class="login-btn" id="loginBtn">
                登录
            </button>

            <!-- 忘记密码 -->
            <div class="forgot-password">
                <a href="#" onclick="showForgotPassword()">忘记密码？</a>
            </div>
        </form>

        <!-- 全局提示 -->
        <div class="toast" id="toast"></div>
    </div>
</div>
```

#### CSS 样式要点

```css
/* 整体布局 */
- 居中设计（flexbox）
- 渐变背景（现代感）
- 卡片阴影效果

/* 表单元素 */
- 输入框：圆角、边框动画
- 按钮：主色调、悬停效果
- 标签：清晰可读

/* 响应式设计 */
- 移动端适配（max-width: 480px）
- 平板适配（max-width: 768px）
- 触摸友好的按钮尺寸

/* 动画效果 */
- 输入框焦点过渡
- 错误提示淡入淡出
- 按钮加载状态旋转
```

#### 颜色方案

```
主色调: #4A90E2 (蓝色)
成功色: #52C41A (绿色)
错误色: #F5222D (红色)
背景渐变: linear-gradient(135deg, #667eea 0%, #764ba2 100%)
文字颜色: #333333
次要文字: #666666
```

### ✅ 设计完成

**下一步**: C2 (开发窗口) 请根据此设计实现代码

**设计文件**: `login.html`
**预计复杂度**: 中等
**预计时间**: 20-30 分钟

### 📋 测试要点

C3 测试时需要验证：
1. ✅ 空表单提交时的验证
2. ✅ 用户名长度验证（< 3 或 > 20）
3. ✅ 密码长度验证（< 6 或 > 20）
4. ✅ 正确的登录（demo/demo123）
5. ✅ 错误的登录提示
6. ✅ "记住我" 功能
7. ✅ 密码可见性切换
8. ✅ 响应式布局（移动端/桌面端）

---
**设计完成时间**: 2025-01-27 20:50
**设计窗口**: C1
**任务索引**: 1
